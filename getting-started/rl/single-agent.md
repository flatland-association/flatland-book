Single agent
===

```{admonition} Goal
At the end of this Tutorial, you will be able to train a single agent to navigate in Flatland using DQN!
```

We use the [`training_navigation.py`](https://gitlab.aicrowd.com/flatland/baselines/blob/master/torch_training/training_navigation.py) file to train a simple agent with the tree observation to solve the navigation task.

Setting up the environment
---

Before you get started with the training, make sure that you have [pytorch](https://pytorch.org/get-started/locally/) installed.

We start by importing the necessary flatland modules:

```python
from flatland.envs.generators import complex_rail_generator
from flatland.envs.observations import TreeObsForRailEnv
from flatland.envs.rail_env import RailEnv
from flatland.utils.rendertools import RenderTool
from utils.observation_utils import norm_obs_clip, split_tree
```

For this simple example we want to train on randomly generated levels using the `complex_rail_generator`. We use the following parameter for our first experiment:

```python
# Parameters for the Environment
x_dim = 10
y_dim = 10
n_agents = 1
n_goals = 5
min_dist = 5
```

For this experiment we will use the tree observation:

```python
# We are training an Agent using the Tree Observation with depth 2
observation_builder = TreeObsForRailEnv(max_depth=2)
```

We then pass it as an argument to the environment constructor:

```python
env = RailEnv(width=x_dim,
              height=y_dim,
              rail_generator=complex_rail_generator(nr_start_goal=n_goals, nr_extra=5, min_dist=min_dist,
                                                    max_dist=99999,
                                                    seed=0),
              obs_builder_object=observation_builder,
              number_of_agents=n_agents)
```

We have now successfully set up the environment for training!

In order to visualize it in the renderer we initiate the renderer with:

```python
env_renderer = RenderTool(env, gl="PILSVG", )
```

Setting up the agent
---

To set up an appropriate agent we need the state and action space sizes. We calculate this based on the tree depth and its number of features:

```python
# Given the depth of the tree observation and the number of features per node we get the following state_size
features_per_node = 9
tree_depth = 2
nr_nodes = 0
for i in range(tree_depth + 1):
    nr_nodes += np.power(4, i)
state_size = features_per_node * nr_nodes

# The action space of flatland is 5 discrete actions
action_size = 5
```

In the `training_navigation.py` file you will find further bookkeeping variable that we initiate in order to keep track of the training progress. We omit them here for brevity. 

It is important to note that we reshape and normalize the tree observation provided by the environment to facilitate training. To do so, we use the utility functions `split_tree(tree=np.array(obs[a]), num_features_per_node=features_per_node, current_depth=0)` and `norm_obs_clip()`.

```python
# Split the observation tree into its parts and normalize the observation using the utility functions.
# Build agent specific local observation
for a in range(env.get_num_agents()):
    rail_data, distance_data, agent_data = split_tree(tree=np.array(obs[a]),
                                                      num_features_per_node=features_per_node,
                                                      current_depth=0)
    rail_data = norm_obs_clip(rail_data)
    distance_data = norm_obs_clip(distance_data)
    agent_data = np.clip(agent_data, -1, 1)
    agent_obs[a] = np.concatenate((np.concatenate((rail_data, distance_data)), agent_data))
```

We now use the normalized `agent_obs` in our training loop:

```python
for trials in range(1, n_trials + 1):

    # Reset environment
    obs, info = env.reset(True, True)
    if not Training:
        env_renderer.set_new_rail()

    # Split the observation tree into its parts and normalize the observation using the utility functions.
    # Build agent specific local observation
    for a in range(env.get_num_agents()):
        rail_data, distance_data, agent_data = split_tree(tree=np.array(obs[a]),
                                                          num_features_per_node=features_per_node,
                                                          current_depth=0)
        rail_data = norm_obs_clip(rail_data)
        distance_data = norm_obs_clip(distance_data)
        agent_data = np.clip(agent_data, -1, 1)
        agent_obs[a] = np.concatenate((np.concatenate((rail_data, distance_data)), agent_data))

    # Reset score and done
    score = 0
    env_done = 0

    # Run episode
    for step in range(max_steps):

        # Only render when not triaing
        if not Training:
            env_renderer.renderEnv(show=True, show_observations=True)

        # Chose the actions
        for a in range(env.get_num_agents()):
            if not Training:
                eps = 0

            action = agent.act(agent_obs[a], eps=eps)
            action_dict.update({a: action})

            # Count number of actions takes for statistics
            action_prob[action] += 1

        # Environment step
        next_obs, all_rewards, done, _ = env.step(action_dict)

        for a in range(env.get_num_agents()):
            rail_data, distance_data, agent_data = split_tree(tree=np.array(next_obs[a]),
                                                              num_features_per_node=features_per_node,
                                                              current_depth=0)
            rail_data = norm_obs_clip(rail_data)
            distance_data = norm_obs_clip(distance_data)
            agent_data = np.clip(agent_data, -1, 1)
            agent_next_obs[a] = np.concatenate((np.concatenate((rail_data, distance_data)), agent_data))

        # Update replay buffer and train agent
        for a in range(env.get_num_agents()):

            # Remember and train agent
            if Training:
                agent.step(agent_obs[a], action_dict[a], all_rewards[a], agent_next_obs[a], done[a])

            # Update the current score
            score += all_rewards[a] / env.get_num_agents()

        agent_obs = agent_next_obs.copy()
        if done['__all__']:
            env_done = 1
            break

    # Epsilon decay
    eps = max(eps_end, eps_decay * eps)  # decrease epsilon
```

Results
---

Running the `training_navigation.py` file trains a simple agent to navigate to any random target within the railway network. After running you should see a learning curve similar to this one:

![Learning_curve](https://i.imgur.com/yVGXpUy.png)

and the agent behavior should look like this:

![Single_Agent_Navigation](https://i.imgur.com/t5ULr4L.gif)
