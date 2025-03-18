Speed profiles
==============

<!-- ```{note}
Speed profiles are not used in the [NeurIPS 2020 challenge](https://www.aicrowd.com/challenges/neurips-2020-flatland-challenge/).
``` -->

<!-- ```{warning}
This page is outdated and needs to be reviewed, handle with care.
``` -->

One of the main contributions to the complexity of railway network operations stems from the fact that all trains travel at different speeds while sharing a very limited railway network.
In **Flat**land 3 this feature will be enabled as well and will lead to much more complex configurations. Here we count on your support if you find bugs or improvements  :).

The different speed profiles can be generated using the `schedule_generator`, where you can actually chose as many different speeds as you like.
Keep in mind that the *fastest speed* is 1 and all slower speeds must be between 1 and 0.
For the submission scoring you can assume that there will be no more than 5 speed profiles.



Later versions of **Flat**land might have varying speeds during episodes. Therefore, we return the agent speeds.
Notice that we do not guarantee that the speed will be computed at each step, but if not costly we will return it at each step.
In your controller, you can get the agents' speed from the `info` returned by `step`:
```python
obs, rew, done, info = env.step(actions)
...
for a in range(env.get_num_agents()):
    speed = info['speed'][a]
```

## Actions and observation with different speed levels

Because the different speeds are implemented as fractions the agents ability to perform actions has been updated.
We **do not allow actions to change within the cell**.
This means that each agent can only chose an action to be taken when entering a cell.
This action is then executed when a step to the next cell is valid. For example

- Agent enters switch and choses to deviate left. Agent fractional speed is 1/4 and thus the agent will take 4 time steps to complete its journey through the cell. On the 4th time step the agent will leave the cell deviating left as chosen at the entry of the cell.
    - All actions chosen by the agent during its travels within a cell are ignoredm. Except STOP_MOVING, if stop action is provided then the agent's speed counter is not updated.
    - Agents can make observations at any time step. Make sure to discard observations without any information. See this [example](https://gitlab.aicrowd.com/flatland/baselines/blob/master/torch_training/training_navigation.py) for a simple implementation.
- The environment checks if agent is allowed to move to next cell only at the time of the switch to the next cell

In your controller, you can check whether an agent requires an action by checking `info`:
```python
obs, rew, done, info = env.step(actions)
...
action_dict = dict()
for a in range(env.get_num_agents()):
    if info['action_required'][a] and info['malfunction'][a] == 0:
        action_dict.update({a: ...})

```
Notice that `info['action_required'][a]` does not mean that the action will have an effect:
if the next cell is blocked or the agent breaks down, the action cannot be performed and an action will be required again in the next step.

