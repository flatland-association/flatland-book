# Single agent setting

```{admonition} TL;DR
We use Flatland as a single agent environment to make it easier to train using simple methods. This doesn't scale well but can be used to test new methods and check the efficiency of new observations!
```


### 💡 The idea

Multi-agent problems are by nature more complicated than standard reinforcement learning problem.

As a first step, we 


### 📈 Results
---

We can see that the policy can easily handle a single agent. However, as the number of agent grows, the performance quickly diminishes.

![](https://i.imgur.com/dNqL3tn.png)

The episode length is lower with 2 agents compared to 3 agents, but stays over 200, which is excessive for such small environments.

![](https://i.imgur.com/Jzhbc86.png)

Only in the 1-agent does the policy manage to consistently bring most of the agents to their targets.

![](https://i.imgur.com/ixq1cXP.png)

[Full W&b report](https://app.wandb.ai/masterscrat/flatland/reports/Flatland%3A-Single-Policy-for-Multiple-Agents--Vmlldzo5NzQwOA)

### 🔗 Links

* [Single agent approach from InstaDeep](https://github.com/instadeepai/gtc-course-2020)
* [MARL primer](https://arxiv.org/abs/1911.10635)


### 🌟 Credits

* [Sharada Mohanty](https://twitter.com/MeMohanty/) - idea
* [Florian Laurent](https://twitter.com/MasterScrat/) - implementation