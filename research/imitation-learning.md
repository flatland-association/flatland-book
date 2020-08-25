Imitation Learning
==================

Operations Research approaches give very good results in the Flatland environment, but they don't scale to larger problems. On the other hand, Reinforcement Learning solutions scale well, but they provide mixed results.

A promising approach would be to do Imitation Learning (IL): train RL algorithms to imitate OR solutions. This could provide the "best of both worlds": solutions that scale well and that learned to plan optimal paths!

There are two ways to generate expert demonstrations to do IL:

- Generate the demonstrations "on-the-fly", at the same time as the RL algorithm is learning
- Generate the demonstrations to build a "fixed dataset", before starting to train the RL algorithm

The first solution provides more flexibility, as the agent can learn from any environments without needing any preparation time. With the second approach the environments first need to be solved the OR methods, then the RL algorithms can start training. On the other end, with the second method, this generation phase only has to happen once, while generating demonstrations on-the-fly will slow down any subsequent RL training session. 

```{admonition} Where to find expert solutions?
You can use the top solutions from previous Flatland challenges to generate "expert" solutions. You can [find them listed here](top-challenge-solutions).
The solution from [Team CkUa](https://flatland.aicrowd.com/research/top-challenge-solutions.html#second-place) is a good starting point as it is fast, robust, and written in intelligible Python code.
```

Our research baselines include full implementations of various IL methods: DQfD, Ape-X and MARWIL. Both approaches (on-the-fly and fixed datasets) are implemented.

### On-The-Fly

The idea is to run an expert solution along with the RL algorithm that you are training. More coming soon...


### Fixed Dataset 

We provide tools to **record** expert demonstration, and to **convert them** into any format you may need to train RL agents.

To record expert demonstration, use the `flatland-evaluator` utility.  