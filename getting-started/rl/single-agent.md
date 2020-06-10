Single agent
===

```{admonition} Goal
At the end of this tutorial, you will be able to train a single agent to navigate in Flatland using DQN!
```

We use the [`single_agent_training.py`](https://gitlab.aicrowd.com/flatland/flatland-examples/blob/master/reinforcement_learning/single_agent_training.py) file to train a simple agent with the tree observation to solve the navigation task. This tutorial walks you through this file step by step.

Setting up the environment
---

Before you get started with the training, you will need to have [PyTorch](https://pytorch.org/get-started/locally/) installed. You can install everything you need using the `requirements.txt` file:

```console
$ pip install -r requirements.txt
```

We start by importing the necessary flatland modules:

```python
from flatland.envs.rail_env import RailEnv
from flatland.envs.rail_generators import sparse_rail_generator
from flatland.envs.schedule_generators import sparse_schedule_generator
from utils.observation_utils import normalize_observation
from flatland.envs.observations import TreeObsForRailEnv
```

For this simple example we want to train on randomly generated levels using the `sparse_schedule_generator`. We use the following parameter for our first experiment:

```python
# Parameters for the Environment
x_dim = 35
y_dim = 35
n_agents = 1
```

It is possible to use multiple speed profiles, which simulate different kinds of trains. In the NeurIPS 2020 challenge, we only consider trains with a speed of `1.0`, so we setup the speed profiles accordingly below: 

```python
# Different agent types (trains) with different speeds.
speed_ration_map = {
    1.: 1.0,  # 100% of fast passenger train
    1. / 2.: 0.0,  # 0% of fast freight train
    1. / 3.: 0.0,  # 0% of slow commuter train
    1. / 4.: 0.0  # 0% of slow freight train
}
```

For this experiment we will use the tree observation:

```python
# We are training an Agent using the Tree Observation with depth 2
observation_builder = TreeObsForRailEnv(max_depth=2)
```

We then pass it as an argument to the environment constructor:

```python
env = RailEnv(
        width=x_dim,
        height=y_dim,
        rail_generator=sparse_rail_generator(
            max_num_cities=3,  # Number of cities in map (where train stations are)
            seed=1,  # Random seed
            grid_mode=False,
            max_rails_between_cities=2,
            max_rails_in_city=3
        ),
        schedule_generator=sparse_schedule_generator(speed_ration_map),
        number_of_agents=n_agents,
        malfunction_generator_and_process_data=malfunction_from_params(stochastic_data),
        obs_builder_object=tree_observation
    )
```

We have now successfully set up the environment for training!

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

It is important to note that we reshape and normalize the tree observation provided by the environment to facilitate training. To do so, we use the utility functions `normalize_observation(observation: TreeObsForRailEnv.Node, tree_depth: int, observation_radius=0)` defined [in the utils folder](https://gitlab.aicrowd.com/flatland/flatland-examples/blob/master/utils/observation_utils.py).

```python
# Build agent specific observations
for a in range(env.get_num_agents()):
    if obs[a]:
        agent_obs[a] = normalize_observation(obs[a], tree_depth, observation_radius=10)
```

We now use the normalized `agent_obs` in our training loop:

```python
for episode_idx in range(1, n_episodes + 1):
    # Reset environment
    obs, info = env.reset(True, True)
    # Build agent specific observations
    for a in range(env.get_num_agents()):
        if obs[a]:
            agent_obs[a] = normalize_observation(obs[a], tree_depth, observation_radius=10)
            agent_prev_obs[a] = agent_obs[a].copy()

    # Reset score and done
    score = 0
    env_done = 0

    # Run episode
    for step in range(max_steps):
        # Action
        for a in range(env.get_num_agents()):
            if info['action_required'][a]:
                # If an action is require, we want to store the obs at that step as well as the action
                update_values = True
                action = agent.act(agent_obs[a], eps=eps)
                action_prob[action] += 1
            else:
                update_values = False
                action = 0
            action_dict.update({a: action})

        # Environment step
        next_obs, all_rewards, done, info = env.step(action_dict)
        # Update replay buffer and train agent
        for a in range(env.get_num_agents()):
            # Only update the values when we are done or when an action was taken and thus relevant information is present
            if update_values or done[a]:
                agent.step(agent_prev_obs[a], agent_prev_action[a], all_rewards[a], agent_obs[a], done[a])
                cumulated_reward[a] = 0.

                agent_prev_obs[a] = agent_obs[a].copy()
                agent_prev_action[a] = action_dict[a]

            if next_obs[a]:
                agent_obs[a] = normalize_observation(next_obs[a], tree_depth, observation_radius=10)

            score += all_rewards[a] / env.get_num_agents()

        # Copy observation
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