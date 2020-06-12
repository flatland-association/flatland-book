Flatland Environment
====================

```{admonition} TL;DR
This document introduces the main concepts you'll need to get started with Flatland.
```

Our goal is to manage traffic in railway networks. Let's consider a concrete example:

<video controls="controls" muted="muted" autoplay="autoplay" loop="loop" class="media" width="600" height="600" src="https://aicrowd-production.s3.eu-central-1.amazonaws.com/misc/flatland-rl-Media/e2fbaf24-53de-4802-9995-3985dec3c971.mp4"></video>
*Solution from 2019 winner [mugurelionut](https://www.aicrowd.com/participants/mugurelionut)*

In the animation above, you can see multiple agents (the trains) moving from their initial positions to their targets. The movements of the trains are limited by the rails: they are only allowed to move forward, can turn left or right at intersections, and can turn around at dead-ends.

Looking carefully, you can see that some of the trains sometimes "malfunction": they suffer a breakdown of some sort. As a result, they are immobilised for a random duration. Malfunctions are shown in the animation with black crosses **X**.

The goal in Flatland is simple:

> **We seek to minimize the time it takes to bring all the agents to their respective target.** 

This raises a number of questions:

- **Actions:** what can the agents do?
- **Observations:** what can each agent "see"?
- **Rewards:** what is the metric used to evaluate the agents?

↔️ Actions
---

The trains in Flatland have strongly limited movements, as you would expect from a railway simulation. This means that only a few actions are valid in most cases.

Hare are the possible actions:

- **`DO_NOTHING`**:  If the agent is already moving, it continues moving. If it is stopped, it stays stopped. Special case: if the agent is at a dead-end, this action will result in the train turning around.
- **`MOVE_LEFT`**: This action is only valid at cells where the agent can change direction towards the left. If chosen, the left transition and a rotation of the agent orientation to the left is executed. If the agent is stopped, this action will cause it to start moving in any cell where forward or left is allowed!
- **`MOVE_FORWARD`**: The agent will move forward. This action will start the agent when stopped. At switches, this will chose the forward direction.
- **`MOVE_RIGHT`**: The same as deviate left but for right turns.
- **`STOP_MOVING`**: This action causes the agent to stop.

```{admonition} Code reference
The actions are defined in [flatland.envs.rail_env.RailEnvActions](https://gitlab.aicrowd.com/flatland/flatland/blob/master/flatland/envs/rail_env.py#L45).

You can refer to the directions in your code using eg `RailEnvActions.MOVE_FORWARD`, `RailEnvActions.MOVE_RIGHT`...
```

👀 Observations
---

In Flatland, you have full control over the observations that your agents will work with. Three observations are provided as starting point. However, you are encouraged to implement your own.

The three provided observations are:
- Global grid observation
- Local grid observation
- Tree observation

![stock observations](https://i.imgur.com/oo8EIYv.png)

***Global, local and tree:** A visual summary of the three provided observations.*

**[🔗 Provided observations](env/observations)**

```{admonition} Code reference
The provided observations are defined in [envs/observations.py](https://gitlab.aicrowd.com/flatland/flatland/blob/master/flatland/envs/observations.py)
```

Each of the provided observation has its strengths and weaknesses. However, it is unlikely that you will be able to solve the problem by using any single one of them directly. Instead you will need to design your own observation, which can be a combination of the existing ones or which could be radically different.

**[🔗 Create your own observations](env/custom_observations)**


🌟 Rewards
----------

At each time step, each agent receives a combined reward which consists of a local and a global reward signal. 

Locally, the agent receives $r_l = −1$ for each time step, and $r_l = 0$ for each time step after it has reached its target location. The global reward signal $r_g = 0$ only returns a non-zero value when all agents have reached their targets, in which case it is worth $r_g = 1$. 

Every agent $i$ receives a reward:

$$r_i(t) = \alpha r_l(t) + \beta r_g(t)$$

$\alpha$ and β are factors for tuning collaborative behavior. This reward creates an objective of finishing the episode as quickly as possible in a collaborative way.

In the [NeurIPS 2020 challenge](https://www.aicrowd.com/challenges/neurips-2020-flatland-challenge#background), the values used are: $\alpha = 1.0$ and $\beta = 1.0$.

```{admonition} Code reference
The reward is calculated in [envs/rail_env.py](https://gitlab.aicrowd.com/flatland/flatland/blob/master/flatland/envs/rail_env.py)
```

🚉 Other concepts
-----------------

### Custom levels

Going further, you will want to run experiment using a variety of environments. You can create custom levels either using multiple random generators, or design them by hands.

**[🔗 Generate custom levels](env/level_generation)**

### Stochasticity

An important aspect of these levels will be their **stochasticity**, which means how often and for how long trains will malfunction. Malfunctions force the agents the reconsider their plans which can be costly. 

**[🔗 Adjust stochasticity](env/stochasticity)**

### Speed profiles

Finally, trains in real railway networks don't all move at the same speed. A freight train will for example be slower than a passenger train. This is an important consideration, as you want to avoid scheduling a fast train behind a slow train!

```{note}
Speed profiles are not used in the first round of the [NeurIPS 2020 challenge](https://www.aicrowd.com/challenges/neurips-2020-flatland-challenge/).
```

**[🔗 Tune speed profiles](env/speed_profiles)**