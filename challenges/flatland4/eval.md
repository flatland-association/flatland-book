Evaluation Metrics
===

The **[Flatland 4 challenge](https://fab.flatland.cloud/suites/24ab2336-a407-4329-b781-d71846250e24)** is the newest competition around the Flatland environment.

In this edition, we are encouraging participants to develop innovative solutions that leverage **reinforcement learning**. The scenario setup and the evaluation metrics are designed accordingly. However, we are still open for other solutions as well, e.g. operations research, and encourage participants to benchmark their state-of-the art algorithms


⚖ Evaluation metrics
---

### Normalized Episode Rewards

The primary metrics uses the **normalized return** from your agents - the higher the better.

What is the **normalized return**?

- The **returns** are the sum of Flatland's default rewards your agents accumulate during each episode as described
  in [rewards.md](../../environment/environment/rewards.md)
- To **normalize** these return, we scale them so that they stays in the range $[0.0, 1.0]$. This makes it possible to compare results between environments of different dimensions and different number of agents.

In code:

```python
normalized_reward = (cumulative_reward / (self.env._max_episode_steps * self.env.get_num_agents())) + 1
```

The episodes finish when all the trains have reached their target, or when the maximum number of time steps is reached. Therefore:

- The **minimum possible value** (i.e. worst possible) is 0.0, which occurs if none of the agents reach their goal during the episode.
- The **maximum possible value** (i.e. best possible) is 1.0, which would occur if all the agents would reach their targets in one time step, which is generally
  not achievable.

### Submission Score

The submission score is the sum of the normalized scenario rewards.

Evaluation is stopped when a submission does not reach the threshold of 25% completed agents within a level (5 scenarios).


### Factors in reward function

The factors for the [reward function](../../environment/environment/rewards.md) in this competition are:

| factor                             | value |
|------------------------------------|:-----:|
| journey not started (cancellation) |   1   |
| cancellation time buffer           |   0   |
| delay at target                    |   1   |
| intermediate stop not served       |  15   |
| intermediate late arrival          |   0.5 |
| intermediate early departure       |   0.5 |
| collision                          | 100   |


⏱ Time and Resource limits
---

The agents have to act within **time limits**:

- You are allowed up to 30 minutes per episode.
- The full evaluation must finish in 2 hours.

The agents are evaluated in a container with **resource limits**

- 4 CPU cores
- 15 GB of main memory.
  We do not provide GPUs.