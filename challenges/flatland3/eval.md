Evaluation Metrics
===

The **[Flatland 3 challenge](https://www.aicrowd.com/challenges/flatland-3)** is the newest competition around the Flatland environment.

In this edition, we are encouraging participants to develop innovative solutions that leverage **reinforcement learning**. The evaluation metrics and prize distribution are designed accordingly.


⚖ Evaluation metrics
---

In this edition, the primary metrics use the **normalized return** from your agents - the higher the better.

What is the **normalized return**?

- The **returns** are the sum of rewards your agents accumulate during each episode.
- To **normalize** these return, we scale them so that they stays in the range $[-1.0, 0.0]$. This makes it possible to compare results between environments of different dimensions. 

In code:

```python
normalized_reward = cumulative_reward / (self.env._max_episode_steps * self.env.get_num_agents())
```

The episodes finish when all the trains have reached their target, or when the maximum number of time steps is reached. Therefore:
- The **minimum possible value** (ie worst possible) is -1.0, which occurs if none of the agents reach their goal during the episode.
- The **maximum possible value** (ie best possible) is 0.0, which would occur if all the agents would reach their targets in one time step, which is generally not achievable.

<!-- The primary metrics is different for each Round:
- In **Round 1**, the normalized returns were averaged over all the evaluation episodes, resulting in the **mean normalized return**.
- In **Round 2**, we add `+1.0` to the normalized return of each episode to make it positive (it is then in the range `[0.0, 1.0]`). We then sum up these normalized returns, which results in the **total normalized return**. -->

You can read more about the [reward structure](env) in the environment documentation.

⏱ Time limits
---

The agents have to act within **time limits**:
 
- You are allowed up to 10 minutes of initial planning time before any agent moves.
- Beyond that point, the agents have 10 seconds per time step to indicate their next actions, no matter the number of agents.
- The full evaluation must finish in 8 hours.

If the agents fail to act in time during either the initial planning or during any time step, the current episode will receive a score of -1.0. The evaluation will then continue from the following episode. Your submission should catch the `TimeoutException` exception when performing a step (`env_step()`) in case a timeout error occurs. If a timeout occurs, you should reset the environment (`env_create()`) before continuing further. See the starter kit for [a concrete example](https://gitlab.aicrowd.com/flatland/neurips2020-flatland-starter-kit/blob/master/run.py#L184).

The agents are evaluated in a container with access to 4 CPU cores (4 hyper-threads of an Intel Xeon E5 v3 at 2.3 GHz base, 3.8 GHz single core max turbo) and 15 GB of main memory. It is also possible to get access to a GPU, contact the organizers if your approach could take advantage of one.