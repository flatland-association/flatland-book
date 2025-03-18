Custom observations
===

Overview
--------

One of the main objectives of the [Flatland challenge](https://gitlab.aicrowd.com/flatland/neurips2020-flatland-baselines) is to find a suitable observation to solve the problems. Three observations are [provided with Flatland out of the box](observations), however it is unlikely that they will be sufficient for this challenge. 

Flatland was built with as much flexibility as possible when it comes to building your custom observations. Whenever an environment needs to compute new observations for each agent, it queries an object derived from the [`ObservationBuilder` base class](https://github.com/flatland-association/flatland-rl/blob/master/flatland/core/env_observation_builder.py#L18), which takes the current state of the environment and returns the desired observation.

We will go through 3 examples to explain how to build custom observations:
- [Simple (but useless) observation](#simple-but-useless-observation)
- [Single-agent navigation](#single-agent-navigation)
- [Using predictors and rendering observations](#using-predictors-and-rendering-observations)

Simple (but useless) observation
--------------------------------

In this first example we implement all the methods necessary for an observation builder to be valid and work with Flatland. This observation builder will simply return a vector of size 5 filled with the ID of the agent. This is a toy example and wouldn't help an actual agent to learn anything. 

Custom observation builders need to derive from the [`flatland.core.env_observation_builder.ObservationBuilder`](https://github.com/flatland-association/flatland-rl/blob/master/flatland/core/env_observation_builder.py#L18) base class and must implement at least two methods, `reset(self)` and `get(self, handle)`.

Below is a simple example that returns observation vectors of size 5 featuring only the ID (handle) of the agent whose observation vector is
being computed:

```python
class SimpleObs(ObservationBuilder):
    """
    Simplest observation builder. The object returns observation vectors with 5 identical components,
    all equal to the ID of the respective agent.
    """

    def reset(self):
        return

    def get(self, handle):
        observation = handle * np.ones(5)
        return observation
```

We can pass an instance of our custom observation builder `SimpleObs` to the `RailEnv` creator as follows:

```python

env = RailEnv(width=30,
              height=30,
              number_of_agents=3,
              rail_generator=sparse_rail_generator(),
              line_generator=sparse_line_generator(),
              obs_builder_object=SimpleObs())

env.reset()
```

Anytime `env.reset()` or `env.step()` is called, the observation builder will return the custom observation of all agents initialized in the env. Not very useful, but it is a start! 

The code sample above is available in [`custom_observation_example_01_SimpleObs.py`](https://github.com/flatland-association/flatland-rl/blob/master/examples/custom_observation_example_01_SimpleObs.py). 

In the next example, we highlight how to inherit from existing observation builders and how to access internal variables of Flatland.

Single-agent navigation
-----------------------

Observation builders can inherit from existing concrete subclasses of [`ObservationBuilder`](https://github.com/flatland-association/flatland-rl/blob/master/flatland/core/env_observation_builder.py#L18). For example, it may be useful to extend the [`TreeObsForRailEnv`](https://github.com/flatland-association/flatland-rl/blob/master/flatland/envs/observations.py#L18) observation builder. A feature of this class is that on `reset()`, it pre-computes the lengths of the shortest paths from all cells and orientations to the target of each agent, i.e. a distance map for each agent.

In this example we exploit these distance maps by implementing an observation builder that shows the current shortest path for each agent
as a one-hot observation vector of length 3, whose components represent the possible directions an agent can take (`LEFT`, `FORWARD`, `RIGHT`). All values of the observation vector are set to `0` except for the shortest direction where it is set to `1`.

Using this observation with highly engineered features indicating the agent's shortest path, an agent can then learn to take the corresponding
action at each time-step; or we could even hardcode the optimal policy. Note that this simple strategy fails when multiple agents are present,
as each agent would only attempt its greedy solution, which is not usually [Pareto-optimal](https://en.wikipedia.org/wiki/Pareto_efficiency) in
this context.

```python
from flatland.envs.observations import TreeObsForRailEnv

class SingleAgentNavigationObs(TreeObsForRailEnv):
    """
    We derive our observation builder from TreeObsForRailEnv, to exploit the existing implementation to compute
    the minimum distances from each grid node to each agent's target.

    We then build a representation vector with 3 binary components, indicating which of the 3 available directions
    for each agent (Left, Forward, Right) lead to the shortest path to its target.
    E.g., if taking the Left branch (if available) is the shortest route to the agent's target, the observation vector
    will be [1, 0, 0].
    """
    def __init__(self):
        super().__init__(max_depth=0)
        # We set max_depth=0 in because we only need to look at the current
        # position of the agent to decide what direction is shortest.

    def reset(self):
        # Recompute the distance map, if the environment has changed.
        super().reset()

    def get(self, handle):
        # Here we access agent information from the environment.
        # Information from the environment can be accessed but not changed!
        agent = self.env.agents[handle]

        possible_transitions = self.env.rail.get_transitions(*agent.position, agent.direction)
        num_transitions = np.count_nonzero(possible_transitions)

        # Start from the current orientation, and see which transitions are available;
        # organize them as [left, forward, right], relative to the current orientation
        # If only one transition is possible, the forward branch is aligned with it.
        if num_transitions == 1:
            observation = [0, 1, 0]
        else:
            min_distances = []
            for direction in [(agent.direction + i) % 4 for i in range(-1, 2)]:
                if possible_transitions[direction]:
                    new_position = self._new_position(agent.position, direction)
                    min_distances.append(self.env.distance_map.get()[handle, new_position[0], new_position[1], direction])
                else:
                    min_distances.append(np.inf)

            observation = [0, 0, 0]
            observation[np.argmin(min_distances)] = 1

        return observation

env = RailEnv(width=30,
              height=30,
              number_of_agents=2,
              rail_generator=sparse_rail_generator(),
              line_generator=sparse_line_generator(),
              obs_builder_object=SingleAgentNavigationObs())

env.reset()

obs, all_rewards, done, _ = env.step({0: 0, 1: 1})
for i in range(env.get_num_agents()):
    print(obs[i])
```

Finally, the following is an example of hard-coded navigation for single agents that achieves optimal single-agent navigation to target, and shows the path taken as an animation.

```python
env = RailEnv(width=30,
              height=30,
              number_of_agents=1,
              rail_generator=sparse_rail_generator(),
              line_generator=sparse_line_generator(),
              obs_builder_object=SingleAgentNavigationObs())
env.reset()

obs, all_rewards, done, _ = env.step({0: 0})

env_renderer = RenderTool(env)
env_renderer.render_env(show=True, frames=True, show_observations=False)

for step in range(100):
    action = np.argmax(obs[0])+1
    obs, all_rewards, done, _ = env.step({0:action})
    print("Rewards: ", all_rewards, "  [done=", done, "]")

    env_renderer.render_env(show=True, frames=True, show_observations=False)
    time.sleep(0.1)
```

The code sample above is available in [`custom_observation_example_02_SingleAgentNavigationObs.py`](https://github.com/flatland-association/flatland-rl/blob/master/examples/custom_observation_example_02_SingleAgentNavigationObs.py).

Using predictors and rendering observations
-------------------------------------------

Because the re-scheduling task of the [Flatland challenge](https://www.aicrowd.com/challenges/neurips-2020-flatland-challenge/) requires some short term planning, we allow the possibility to use custom predictors that help predict upcoming conflicts and help agent solve them in a timely manner. 

The Flatland environment comes with a built-in predictor called [`ShortestPathPredictorForRailEnv`](https://github.com/flatland-association/flatland-rl/blob/master/flatland/envs/predictions.py#L85), to give you an idea what you can do with these predictors.

Any custom predictor can be passed to the observation builder and will then be used to build the observation. In this example we will illustrate how an observation builder can be used to detect conflicts using a predictor.

Note that the toy `ObservePredictions` observation we will create only contains information about potential conflicts and has no feature about the agents' objectives, so it wouldn't be sufficient to solve real tasks!

You can also render your custom observation or predictor information as an overlay on the environment. All you need to do in order to render your custom observation is to populate `self.env.dev_obs_dict[handle]` for every agent (all handles). For the predictor, you can similarly use `self.env.dev_pred_dict[handle]`.

In contrast to the previous examples, we also implement the `def get_many(self, handles=None)` function for this custom observation builder. The reasoning here is that we want to call the predictor only once per `env.step()`. The base implementation of `def get_many(self, handles=None)` will call the `get(handle)` function for all handles, which mean that it normally does not need to be reimplemented, except for cases such as this one.

```python
class ObservePredictions(TreeObsForRailEnv):
    """
    We use the provided ShortestPathPredictor to illustrate the usage of predictors in your custom observation.

    We derive our observation builder from TreeObsForRailEnv, to exploit the existing implementation to compute
    the minimum distances from each grid node to each agent's target.

    This is necessary so that we can pass the distance map to the ShortestPathPredictor

    Here we also want to highlight how you can visualize your observation
    """

    def __init__(self, predictor):
        super().__init__(max_depth=0)
        self.predictor = predictor

    def reset(self):
        # Recompute the distance map, if the environment has changed.
        super().reset()

    def get_many(self, handles=None):
        '''
        Because we do not want to call the predictor seperately for every agent we implement the get_many function
        Here we can call the predictor just once for all the agents and use the predictions to generate our observations
        :param handles:
        :return:
        '''

        self.predictions = self.predictor.get()

        self.predicted_pos = {}
        for t in range(len(self.predictions[0])):
            pos_list = []
            for a in handles:
                pos_list.append(self.predictions[a][t][1:3])
            # We transform (x,y) coordinates to a single integer number for simpler comparison
            self.predicted_pos.update({t: coordinate_to_position(self.env.width, pos_list)})
        observations = {}

        # Collect all the different observation for all the agents
        for h in handles:
            observations[h] = self.get(h)
        return observations

    def get(self, handle):
        '''
        Lets write a simple observation which just indicates whether or not the own predicted path
        overlaps with other predicted paths at any time. This is useless for the task of navigation but might
        help when looking for conflicts. A more complex implementation can be found in the TreeObsForRailEnv class

        Each agent receives an observation of length 10, where each element represents a prediction step and its value
        is:
         - 0 if no overlap is happening
         - 1 if any other paths is crossing the predicted cell

        :param handle: handled as an index of an agent
        :return: Observation of handle
        '''

        observation = np.zeros(10)

        # We track what cells where considered while building the observation and make them accessible for rendering
        visited = set()
        
        for _idx in range(10):
            # Check if any of the other prediction overlap with agents own predictions
            x_coord = self.predictions[handle][_idx][1]
            y_coord = self.predictions[handle][_idx][2]

            # We add every observed cell to the observation rendering
            visited.add((x_coord, y_coord))
            if self.predicted_pos[_idx][handle] in np.delete(self.predicted_pos[_idx], handle, 0):
                # We detect if another agent is predicting to pass through the same cell at the same predicted time
                observation[handle] = 1

        # This variable will be access by the renderer to visualize the observation
        self.env.dev_obs_dict[handle] = visited

        return observation
```

We can then use this new observation builder and the renderer to visualize the observation of each agent.

```python
# Create the Predictor
CustomPredictor = ShortestPathPredictorForRailEnv(10)

# Pass the Predictor to the observation builder
CustomObsBuilder = ObservePredictions(CustomPredictor)

# Initiate Environment
env = RailEnv(width=30,
              height=30,
              number_of_agents=3,
              rail_generator=sparse_rail_generator(),
              line_generator=sparse_line_generator(),
              obs_builder_object=CustomObsBuilder)

env.reset()

obs, info = env.reset()
env_renderer = RenderTool(env)

# We render the initial step and show the obsereved cells as colored boxes
env_renderer.render_env(show=True, frames=True, show_observations=True, show_predictions=False)

action_dict = {}
for step in range(100):
    for a in range(env.get_num_agents()):
        action = np.random.randint(0, 5)
        action_dict[a] = action
    obs, all_rewards, done, _ = env.step(action_dict)
    print("Rewards: ", all_rewards, "  [done=", done, "]")
    env_renderer.render_env(show=True, frames=True, show_observations=True, show_predictions=False)
    time.sleep(0.5)
```

The code sample above is available in [`custom_observation_example_03_ObservePredictions.py`](https://github.com/flatland-association/flatland-rl/blob/master/examples/custom_observation_example_03_ObservePredictions.py).

Going further
---

When building your custom observation builder, you might want to aggregate and define your own features that are different from the raw environment data. The [next section](environment_information) explains how to access such information.