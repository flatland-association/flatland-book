Observations
================

In Flatland, you have full control over the observations that your agents will work with. Three observations are provided as starting point. However, you are
encouraged to implement your own.

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

Each of the provided observations has its strengths and weaknesses. However, it is unlikely that you will be able to solve the problem by using any single one of
them directly. Instead you will need to design your own observation, which can be a combination of the existing ones or which could be radically different.

**[🔗 Create your own observations](observation_builder/custom_observations.md)**


