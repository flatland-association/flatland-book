Evaluation Metrics
===

The **[Flatland 4 challenge](https://fab.flatland.cloud/suites/24ab2336-a407-4329-b781-d71846250e24)** is the newest competition around the Flatland
environment.

In this edition, we are encouraging participants to develop innovative solutions that leverage **reinforcement learning**. The scenario setup and the evaluation
metrics are designed accordingly. However, we are still open for other solutions as well, e.g. operations research, and encourage participants to benchmark
their state-of-the art algorithms


⚖ Evaluation metrics
---

### Normalized Episode Rewards

The primary metrics uses the **normalized return** from your agents - the higher the better.

What is the **normalized return**?

- The **returns** are the sum of Flatland's default rewards your agents accumulate during each episode as described
  in [rewards.md](../../environment/environment/rewards.md)
- To **normalize** these return, we scale them so that they stays in the range $[0.0, 1.0]$. To guarantee this, the maximum penalty per agent can be at most
  ```max_episode_steps```. This normalized rewards allows to compare results between environments of different dimensions and different number of agents.

In code:

```python
normalized_reward = sum([max(cumulative_rewards[agent.handle], - self.env.max_episode_steps) for agent in agents]) / (
        self.env.max_episode_steps * self.env.get_num_agents()) + 1
```

The episodes finish when all the trains have reached their target, or when the maximum number of time steps is reached. Therefore:

- The **minimum possible value** (i.e. worst possible) is 0.0, which occurs if none of the agents reach their goal during the episode.
- The **maximum possible value** (i.e. best possible) is 1.0, which would occur if all the agents would reach their targets and intermediate stops on time, i.e.
  not receive any penalty.

### Submission Score

The submission score is the sum of the normalized scenario rewards.

Evaluation is stopped when a submission does not reach the threshold of 25% completed agents within a level (5 scenarios).

### Factors in reward function

The factors for the [reward function](../../environment/environment/rewards.md) in this competition are:

| factor                                    | value |
|-------------------------------------------|:-----:|
| journey not started (cancellation factor) |   5   |
| cancellation time buffer                  |   0   |
| delay at target                           |   1   |
| target not reached minimum penalty        |  100  |
| intermediate stop not served              |  50   |
| intermediate late arrival                 |  0.5  |
| intermediate early departure              |  0.5  |
| collision                                 |  250  |

This configuration is implemented using `--rewards flatland.envs.rewards.ECML2026Rewards`.

⛽ Time and Resource limits
---

The agents have to act within **time limits**:

- You are allowed up to 30 minutes per scenario.
- The full evaluation must finish in 4 hours.

The agents are evaluated in a container with **resource limits**

- 4 CPU cores
- 15 GB of main memory.

We do not provide GPUs.

### Detailed overview over resource limits

| Limit[^1]                       | Value                                                                                    | Submission outcome             | Details                                                                                                 |
|---------------------------------|------------------------------------------------------------------------------------------|--------------------------------|---------------------------------------------------------------------------------------------------------|
| `dailyLimit`                    | `2`                                                                                      | Not created                    | Error in frontend as error `429 TOO_MANY_REQUESTS` from backend.                                        |
| `WAIT_FOR_POD_TO_RUN_LIMIT`     | `300` (5 min)                                                                            | Failure                        | submission pod should be listed by now, i.e. pulling has started by now.                                |
| `WAIT_FOR_POD_TO_START_LIMIT`   | `1200`  (20 min)                                                                         | Failure                        | submission pod should have reached running state by now, i.e. pulling should be done by now             |
| `K8S_RESOURCE_ALLOCATION`       | `{"requests": {"memory": "15Gi", "cpu": "4"}, "limits": {"memory": "15Gi", "cpu": "4"}}` | Failure                        | resource limits for pod running the submission                                                          |
| `RUNNING_TIME_LIMIT`            | `1800`  (30 min)                                                                         | Success with termination cause | per scenario                                                                                            |                                                                                
| `TOTAL_RUNNING_TIME_LIMIT`      | `18000`  (5h)                                                                            | Success with termination cause | all scenarios, excluding technical overhead for starting pods and running offline trajectory evaluation |                                                                                
| `ACTIVE_DEADLINE_SECONDS`       | `21600` (6h)                                                                             | Success with termination cause | everything including technical overhead for starting pods                                               |
| `PERCENTAGE_COMPLETE_THRESHOLD` | `0.25` (25%)                                                                             | Success with termination cause | `Mean percentage of done agents during the last test was too low`                                       |

[^1]: see [implementation](https://github.com/flatland-association/flatland-benchmarks/pull/594/changes)



📪 Daily Submission Limits and Submission Closure.
---
You can submit up to 2 times per day.


