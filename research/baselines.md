RLlib Baselines
===============

```{note}
Looking for simpler RL baselines? Checkout the [DQN examples](../getting-started/rl) implemented from scratch using PyTorch. 
```

The following baselines provide a starting point to develop advanced reinforcement learning solutions. They use the RLlib framework, which makes it easy to scale up training to larger machines or even to clusters of machines.

**🔗 [RLlib Baseline Repository](https://gitlab.aicrowd.com/flatland/neurips2020-flatland-baselines)**

Follow the [getting started guide](baselines/getting-started) to setup and start training using the baselines.

The [RLlib documentation](https://docs.ray.io/en/latest/rllib-algorithms.html) provides ample information about the standard methods such as Ape-X and PPO. The documentation below gives more details about the methods, observations and other approaches that have been developed specifically for Flatland.

### RL methods

- [Centralized Critic PPO](baselines/centralized_critic)
- [Imitation Learning: MARWIL, Ape-X DQfD](baselines/imitation_learning)

### Custom observations

- [Density observations](baselines/global_density_obs)
- [Combining observations](baselines/combined_tree_local_conflict_obs)

### Other approaches

- [Frame skipping](baselines/action_masking_and_skipping)
- [Action masking](baselines/action_masking_and_skipping)
