Metrics and Prizes
==================

The **[NeurIPS 2020 challenge](https://www.aicrowd.com/challenges/neurips-2020-flatland-challenge/)** is the newest competition around the Flatland environment.

In this edition, we are encouraging participants to develop innovative solutions that leverage **reinforcement learning**. The evaluation metrics and prize distribution are designed accordingly.


⚖ Evaluation metrics
---

In this edition, the primary metrics is the **mean normalized return** from your agents - the higher the better.

What is the **mean normalized return**?

- The **return** is the sum of rewards your agents accumulate during each episode.
- These returns are then **averaged** across all the evaluation episodes that take place for each submission.
- To **normalize** this mean return, we scale it so that it stays in the range [-1.0, 0.0]. This makes it possible to compare results between environments of different dimensions. 

In code:

```python
normalized_reward = cumulative_reward / (self.env._max_episode_steps * self.env.get_num_agents())
```

The **minimum possible value** (ie worst possible) is -1.0, which occurs if none of the agents reach their goal during the episode.

The **maximum possible value** (ie best possible) is 0.0, which would occur if all the agents would reach their targets in one time step, which is generally not achievable.

You can read more about the [reward structure](env) in the environment documentation.

⏱ Time limits
---

The agents have to act within **strict time limits**:
 
- You are allowed up to 5 minutes of initial planning time before any agent moves.
- Beyond that point, the agents have 5 seconds per time step to indicate their next actions, no matter the number of agents.

```{warning}
If at any time the agents fail to act in time, the whole submission will fail!
```

The agents will be evaluated in a container with access to 4 CPU cores. It is also possible to get access to a GPU, contact the organizers if your approach could take advantage of one. 


🏆 Prizes
---

**The prizes are four travel grants to the [NeurIPS 2020 conference](http://neurips.cc/Conferences/2020/) ✈️**

- The **first place team** in the final round will be awarded one travel grant, no matter what approach they used.
- The **top three teams** in the final round which used a **reinforcement learning approach** for their winning submission will be awarded one travel grant each.

The approach used for each submission needs to be specified in the `aicrowd.json` file as described in the [submission guide](../getting-started/first-submission). 

The winning submissions will be verified manually by the organizers to ensure the method used matches what has been declared in the `aicrowd.json` file. The organizers have the final word when judging the validity of each submission.

```{note}
In the case where the overall first place team would use a reinforcement learning approach, then this team will be awarded two travel grants.
```