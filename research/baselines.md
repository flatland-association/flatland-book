Baselines
=========

```{note}
Looking for simpler RL baselines? Checkout the [DQN examples](../getting-started/rl) implemented from scratch using PyTorch. 
```

The following baselines provide a starting point to develop advanced reinforcement learning solutions. They use the RLlib framework, which makes it easy to scale up training to larger machines or even to clusters of machines.

We are still hard at work on these baselines, and as such this documentation will keep evolving.
Any addition to the documentation and to the baselines themselves [are very welcome](../../misc/contributing)!

To get started, follow the setup and usage guide in the [baseline repository](https://gitlab.aicrowd.com/flatland/neurips2020-flatland-baselines). The documentation below explains in more details how each of these methods work.

RL methods
-------------

- [Centralized Critic PPO](baselines/centralized_critic)
- [Imitation Learning: MARWIL, Ape-X DQfD](baselines/imitation_learning)

Custom observations
----------------------

- [Density observations](baselines/global_density_obs)
- [Combining observations](baselines/combined_tree_local_conflict_obs)

Other approaches
-------------------

- [Frame skipping](baselines/action_masking_and_skipping)
- [Action masking](baselines/action_masking_and_skipping)

Links
-----

[**🔗 Baseline repository**](https://gitlab.aicrowd.com/flatland/neurips2020-flatland-baselines)