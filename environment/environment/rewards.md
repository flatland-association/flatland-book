Rewards
========

In **Flat**land 3, rewards are only provided at the end of an episode by default making it a sparse reward setting.

The episodes finish when all the trains have reached their target, or when the maximum number of time steps is reached.

The actual reward structure has the following cases:

- **Train has arrived at its target**: The agent will be given a reward of 0 for arriving on time or before the expected time. For arriving at the target later
  than the specified time, the agent is given a negative reward proportional to the delay.
  `min(latest_arrival - actual_arrival, 0)`

- **The train did not reach its target yet**: The reward is negative and equal to the estimated amount of time needed by the agent to reach its target from
  its current position, if it travels on the shortest path to the target, while accounting for its latest arrival time.
  `agent.get_current_delay()` *refer to it in detail [here](../environment/scenario_generation/timetables.md)*
  The value returned will be positive if the expected arrival time is projected before latest arrival and negative if the expected arrival time is projected
  after latest arrival. Since it is called at the end of the episode, the agent is already past its deadline and so the value will always be negative.

- **The train never departed**: If the agent hasn't departed (i.e. status is `READY_TO_DEPART`) at the end of the episode, it is considered to be cancelled and
  the following reward is provided.
  `-1 * cancellation_factor * (travel_time_on_shortest_path + cancellation_time_buffer)`

```{admonition} Code reference
The reward is calculated in [envs/rail_env.py](https://github.com/flatland-association/flatland-rl/blob/main/flatland/envs/rail_env.py)
```
