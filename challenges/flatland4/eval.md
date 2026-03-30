Evaluation Metrics
===

The **[Flatland 3 challenge](https://www.aicrowd.com/challenges/flatland-3)** is the newest competition around the Flatland environment.

In this edition, we are encouraging participants to develop innovative solutions that leverage **reinforcement learning**. The evaluation metrics and prize
distribution are designed accordingly.


⚖ Evaluation metrics
---

### Normalized Episode Rewards

In this edition, the primary metrics use the **normalized return** from your agents - the higher the better.

What is the **normalized return**?

- The **returns** are the sum of Flatland's default rewards your agents accumulate during each episode as described
  in [rewards.md](../../environment/environment/rewards.md)
- To **normalize** these return, we scale them so that they stays in the range $[0.0, 1.0]$. This makes it possible to compare results between environments of
  different dimensions.

In code:

```python
normalized_reward = (cumulative_reward / (self.env._max_episode_steps * self.env.get_num_agents())) + 1
```

The episodes finish when all the trains have reached their target, or when the maximum number of time steps is reached. Therefore:

- The **minimum possible value** (ie worst possible) is 0.0, which occurs if none of the agents reach their goal during the episode.
- The **maximum possible value** (ie best possible) is 1.0, which would occur if all the agents would reach their targets in one time step, which is generally
  not achievable.

### Submission Score

The submission score is the sum of the normalized episode rewards.

Evaluation is stopped when a submission does not reach the threshold of 25% completed agents within a test (10 scenarios).

⏱ Time and Resource limits
---

The agents have to act within **time limits**:

- You are allowed up to 30 minutes per episode.
- The full evaluation must finish in 2 hours.

The agents are evaluated in a container with **resource limits**

- 4 CPU cores
- 15 GB of main memory.
  We do not provide GPUs.