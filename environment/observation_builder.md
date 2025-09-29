Observations
================

In Flatland, you have full control over the observations that your agents will work with. Three observations are provided as starting point. However, you are
encouraged to implement your own.

## Provided Observations

The three provided observations are:

- Global grid observation
- Local grid observation
- Tree observation

![stock observations](https://i.imgur.com/oo8EIYv.png)

***Global, local and tree:** A visual summary of the three provided observations.*

**[🔗 Provided observations](observation_builder/provided_observations)**

```{admonition} Code reference
The provided observations are defined in [envs/observations.py](https://github.com/flatland-association/flatland-rl/blob/main/flatland/envs/observations.py)
```

Each of the provided observations has its strengths and weaknesses. However, it is unlikely that you will be able to solve the problem by using any single one
of
them directly. Instead you will need to design your own observation, which can be a combination of the existing ones or which could be radically different.

## Custom Observations

**[🔗 Create your own observations](observation_builder/custom_observations.md)**

## Gym Observation Builder

There is `GymObservationBuilder` to take an existing `ObservationBuilder` and make it usable for RLlib (`RayMultiAgentWrapper`) and PettingZoo (
`PettingZooParallelEnvWrapper`):

* `FlattenedTreeObsForRailEnv`: Gym-ified and flattened normalized tree observation.
* `GlobalObsForRailEnvGym`: Gym-ified multi-agent `GlobalObsForRailEnv`.

> This feature was introduced in [4.0.4](https://github.com/flatland-association/flatland-rl/pull/85)

## Observation Perturbations

Perturbing observations can be implemented as wrapper around existing observations. The following two wrappers are implemented:

* Wrapper to add Gaussian noise to numpy array based observations.
* Tree obs wrapper to make trains blind for N timesteps according to Poisson.

> This feature was introduced in [4.2.0](https://github.com/flatland-association/flatland-rl/pull/255)
