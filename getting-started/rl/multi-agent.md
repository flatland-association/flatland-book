Multiple Agents
===

```{warning}
This page is outdated and will be reviewed shortly.
```

```{admonition} Goal
At the end of this Tutorial, you will be able to train a **multiple agents** to navigate in Flatland using DQN!
```

We use the [`multi_agent_training.py`](https://gitlab.aicrowd.com/flatland/baselines/blob/master/torch_training/multi_agent_training.py) file to train multiple agents on the avoid conflicts task.

Setting up the environment
---

Let us now train a simple double dueling DQN agent to detect to find its target and try to avoid conflicts on flatland. We start by importing the necessary packages from Flatland. Note that we now also import a predictor from `flatland.envs.predictions`

```
from flatland.envs.generators import complex_rail_generator
from flatland.envs.observations import TreeObsForRailEnv
from flatland.envs.predictions import ShortestPathPredictorForRailEnv
from flatland.envs.rail_env import RailEnv
from utils.observation_utils import norm_obs_clip, split_tree
```

For this simple example we want to train on randomly generated levels using the `complex_rail_generator`. The training curriculum will use different sets of parameters throughout training to enhance generalizability of the solution.

```
# Initialize a random map with a random number of agents
x_dim = np.random.randint(8, 20)
y_dim = np.random.randint(8, 20)
n_agents = np.random.randint(3, 8)
n_goals = n_agents + np.random.randint(0, 3)
min_dist = int(0.75 * min(x_dim, y_dim))
tree_depth = 3
```

As mentioned above, for this experiment we are going to use the tree observation and thus we load the observation builder. Also we are now using the predictor as well which is passed to the observation builder.

```
"""
 Get an observation builder and predictor:
 The predictor will always predict the shortest path from the current location of the agent.
 This is used to warn for potential conflicts --> Should be enhanced to get better performance!
"""
predictor = ShortestPathPredictorForRailEnv()
observation_helper = TreeObsForRailEnv(max_depth=tree_depth, predictor=predictor)
```

And pass it as an argument to the environment setup

```
env = RailEnv(width=x_dim,
              height=y_dim,
              rail_generator=complex_rail_generator(nr_start_goal=n_goals, nr_extra=5, min_dist=min_dist,
                                                    max_dist=99999,
                                                    seed=0),
              obs_builder_object=observation_builder,
              number_of_agents=n_agents)
```

We have no successfully set up the environment for training. To visualize it in the renderer we also initiate the renderer with.

###Setting up the agent

To set up a appropriate agent we need the state and action space sizes. From the discussion above about the tree observation we end up with:


```
num_features_per_node = env.obs_builder.observation_dim
nr_nodes = 0
for i in range(tree_depth + 1):
    nr_nodes += np.power(4, i)
state_size = num_features_per_node * nr_nodes
action_size = 5
```

In the `multi_agent_training.py` file you will find further variable that we initiate in order to keep track of the training progress.
Below you see an example code to train an agent. It is important to note that we reshape and normalize the tree observation provided by the environment to facilitate training.
To do so, we use the utility functions `split_tree(tree=np.array(obs[a]), num_features_per_node=features_per_node, current_depth=0)` and `norm_obs_clip()`. Feel free to modify the normalization as you see fit.

```
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

We now use the normalized `agent_obs` for our training loop:

```
# Do training over n_episodes
    for episodes in range(1, n_episodes + 1):
        """
        Training Curriculum: In order to get good generalization we change the number of agents
        and the size of the levels every 50 episodes.
        """
        if episodes % 50 == 0:
            x_dim = np.random.randint(8, 20)
            y_dim = np.random.randint(8, 20)
            n_agents = np.random.randint(3, 8)
            n_goals = n_agents + np.random.randint(0, 3)
            min_dist = int(0.75 * min(x_dim, y_dim))
            env = RailEnv(width=x_dim,
                          height=y_dim,
                          rail_generator=complex_rail_generator(nr_start_goal=n_goals, nr_extra=5, min_dist=min_dist,
                                                                max_dist=99999,
                                                                seed=0),
                          obs_builder_object=observation_helper,
                          number_of_agents=n_agents)

            # Adjust the parameters according to the new env.
            max_steps = int(3 * (env.height + env.width))
            agent_obs = [None] * env.get_num_agents()
            agent_next_obs = [None] * env.get_num_agents()

        # Reset environment
        obs, info = env.reset(True, True)

        # Setup placeholder for finals observation of a single agent. This is necessary because agents terminate at
        # different times during an episode
        final_obs = agent_obs.copy()
        final_obs_next = agent_next_obs.copy()

        # Build agent specific observations
        for a in range(env.get_num_agents()):
            data, distance, agent_data = split_tree(tree=np.array(obs[a]), num_features_per_node=num_features_per_node,
                                                    current_depth=0)
            data = norm_obs_clip(data, fixed_radius=observation_radius)
            distance = norm_obs_clip(distance)
            agent_data = np.clip(agent_data, -1, 1)
            agent_obs[a] = np.concatenate((np.concatenate((data, distance)), agent_data))

        score = 0
        env_done = 0

        # Run episode
        for step in range(max_steps):

            # Action
            for a in range(env.get_num_agents()):
                action = agent.act(agent_obs[a], eps=eps)
                action_prob[action] += 1
                action_dict.update({a: action})

            # Environment step
            next_obs, all_rewards, done, _ = env.step(action_dict)

            # Build agent specific observations and normalize
            for a in range(env.get_num_agents()):
                data, distance, agent_data = split_tree(tree=np.array(next_obs[a]),
                                                        num_features_per_node=num_features_per_node, current_depth=0)
                data = norm_obs_clip(data, fixed_radius=observation_radius)
                distance = norm_obs_clip(distance)
                agent_data = np.clip(agent_data, -1, 1)
                agent_next_obs[a] = np.concatenate((np.concatenate((data, distance)), agent_data))

            # Update replay buffer and train agent
            for a in range(env.get_num_agents()):
                if done[a]:
                    final_obs[a] = agent_obs[a].copy()
                    final_obs_next[a] = agent_next_obs[a].copy()
                    final_action_dict.update({a: action_dict[a]})
                if not done[a]:
                    agent.step(agent_obs[a], action_dict[a], all_rewards[a], agent_next_obs[a], done[a])
                score += all_rewards[a] / env.get_num_agents()

            # Copy observation
            agent_obs = agent_next_obs.copy()

            if done['__all__']:
                env_done = 1
                for a in range(env.get_num_agents()):
                    agent.step(final_obs[a], final_action_dict[a], all_rewards[a], final_obs_next[a], done[a])
                break

        # Epsilon decay
        eps = max(eps_end, eps_decay * eps)  # decrease epsilon

        # Collection information about training
        done_window.append(env_done)
        scores_window.append(score / max_steps)  # save most recent score
        scores.append(np.mean(scores_window))
        dones_list.append((np.mean(done_window)))
```

Results
---

Running the `multi_agent_training.py` file trains a simple agent to navigate to any random target within the railway network. After running you should see a learning curve similiar to this one:

![Learning_Curve](https://i.imgur.com/Po4j4yK.png)

and the agent behavior should look like this:

![Conflict_Avoidence](https://i.imgur.com/AvBHKaD.gif)
