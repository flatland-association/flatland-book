The Flatland Environment
===

```{admonition} TL;DR
This document introduces the main concepts you'll need to get started with Flatland.
```

Our goal is to manage traffic in railway networks. Let's consider a concrete example, which shows the solution from the 2019 winner [mugurelionut](https://www.aicrowd.com/participants/mugurelionut):

<video controls="controls" muted="muted" autoplay="autoplay" loop="loop" class="media" width="600" height="600" src="https://aicrowd-production.s3.eu-central-1.amazonaws.com/misc/flatland-rl-Media/e2fbaf24-53de-4802-9995-3985dec3c971.mp4"></video>

In the animation above, you can see multiple agents (the trains) moving from their initial positions to their targets. The trains can, obviously, only move on the rails. They can only move forward, turn left or right at intersections, and turn around at dead-ends.

Looking carefully, you can see that some of the trains sometimes "malfunction": they suffer a breakdown of some sort. As a result, they are immobilised for a random duration. Malfunctions are shown in the animation with black crosses **X**.

The goal in Flatland is simple:

> **We seek to minimize the time it takes to bring all the agents to their respective target.** 

We will now introduce the main concepts underlying this environment:

- **Actions:** what can the agents do?
- **Observations:** what can each agent "see"?
- **Rewards:** what is the metric used to evaluate the agents?

↔️ Actions
---

The trains in Flatland have strongly limited movements, as you would expect from a railway simulation. This means that in most cases only a few actions are valid.

Hare are the possible actions:
- **Do Nothing**:  If the agent is already moving, it continues moving. If it is stopped, it stays stopped. Special case: if the agent is at a dead-end, this action will result in the train turning around.
- **Deviate Left**: This action is only valid at cells where the agent can change direction towards the left. If chosen, the left transition and a rotation of the agent orientation to the left is executed. If the agent is stopped, this action will cause it to start moving in any cell where forward or left is allowed!
- **Go Forward**: This action will start the agent when stopped. At switches, this will chose the forward direction.
- **Deviate Right**: The same as deviate left but for right turns.
- **Stop**: This action causes the agent to stop.

```{admonition} Code reference
The actions are defined as an `IntEnum`: [envs/rail_env.py#L45](https://gitlab.aicrowd.com/flatland/flatland/blob/master/flatland/envs/rail_env.py#L45)
You can refer to the directions in your code using eg `RailEnvActions.MOVE_FORWARD`, `RailEnvActions.MOVE_RIGHT`...
```

👀 Observations
---

In Flatland, you have full control over the observations that your agents will work with. Three observations are provided as starting point. However, you are encouraged to implement your own.

The three provided observations are:
- Global observation
- Local grid observation
- Local tree observation

![stock observations](https://i.imgur.com/oo8EIYv.png)

*A visual summary of the three provided observations.*

**[🔗 Provided observations](env/observations)**

Each of these provided observations has its strengths and weaknesses. It is unlikely that you will be able to solve the problem by using any one of them directly, instead, you will need to design your own observation yourself, which can be a combination of the existing ones or which could be radically different.

**[🔗 Create your own observations](env/observations)**

```{admonition} Code reference
The observations are defined in [envs/observations.py](https://gitlab.aicrowd.com/flatland/flatland/blob/master/flatland/envs/observations.py)
```

🌟 Rewards
---

Each agent receives combined reward consisting of a local and a global reward signal. 

Locally, the agent receives $r_l = −1$ for each time step it is moving, and $r_l = 0$ for each time step after it has reached its target location. The global reward signal $r_g = 0$ only returns a non-zero value when all agents have reached their targets, in which case it is owrth $r_g = 1$. 

Thus, every agent $i$ receives a reward:

$$r_i(t) = α r_l(t) + β r_g(t) + r_i(t)$$

where α and β are factors for tuning collaborative behavior. 

This reward creates an objective of finishing the episode as quickly as possible in a collaborative way. 