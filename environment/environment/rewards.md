Rewards
========


The Flatland scoring function is designed to capture key operational metrics such as punctuality, efficiency in responding to disruptions, and safety.
Punctuality and schedule adherence are rewarded based on the difference between actual and target arrival and departure times at each stop respectively,
as well as penalties for intermediate stops not served or even journeys not started.
Safety measures are implemented as penalties for collisions which are directly proportional to the train’s speed at impact, ensuring that high-speed operations
are managed with extra caution.

More formally, the score
```math
\begin{align}
S &= \sum_{i=1}^N g_i
\end{align}
```
is the sum of all rewards $g_i$ of agent $i$. The reward $g_i$ of an agent consists of a reward at the end of the episode as well as at each timestep $t$.
Per-timestep rewards only consist of a penalty if the train crashes, i.e., collides with another train that occupies the same cell. The collision penalty is
proportional to the current speed $v(t)$ of the train. The reward of an agent is

```math
\begin{align}
g = &
% delay at target:
\underbrace{\mathrm{A}_J \cdot  \min \{\mathrm{A}_J - a_J,0\}}_{\text{delay at target}}  
% journey not started:
+ \underbrace{(1 - \Delta_0) \cdot \phi \cdot (p + \pi)}_{\text{journey not started}}
% target not reached:
+ \underbrace{(1 - \mathrm{A}_J) \cdot d}_{\text{target not reached}}\\
& + \sum_{j=2}^{J-1} \Big[
% intermediate late arrival
\underbrace{\mathrm{A}_j \cdot \alpha \cdot \min \{\mathrm{A}_j - a_j,0\}}_{\text{late arrival}}
% intermediate stop not served
+ \underbrace{(1 - \mathrm{A}_j) \cdot \mu}_{\text{stop not served}}
% intermediate early departure
+ \underbrace{\Delta_j \cdot \delta \cdot \min \{ d_j - \delta_j, 0 \}}_{\text{early departure}} \Big] \\
% collision
& + \sum_{t=1}^T  \underbrace{\mathrm{K}_t \cdot \kappa \cdot v(t)}_{\text{collision}} \ ,
\end{align}
```

where $J$ is the number of stops (including the departure at the start, but including the target) and $T$ is the number of timesteps of the episode.
The symbols are described in Table~\ref{tab:events}.

| event            | penalty factor | scheduled      | actual | description                                                                                               |
|------------------|----------------|----------------|--------|-----------------------------------------------------------------------------------------------------------|
| $\mathrm{A}_J$   | 1              | $\mathrm{A}_J$ | $a_J$  | $\mathrm{A}_J$ latest arrival and $a_J$ actual arrival at target $J$                                      |
| $\Delta_0$       | $\phi$, $\pi$  |                | $p$    | cancellation factor $\phi$ and buffer $\pi$,    <br/> $p$ is the shortest path from start to target       |
| $1-\mathrm{A}_J$ | 1              |                | $d$    | time $d$ remaining on shortest path towards target                                                        |
| $\mathrm{A}_j$   | $\alpha$       | $\mathrm{A}_j$ | $a_j$  | latest arrival $\mathrm{A}_j$, actual arrival time $a_j$    <br/> at intermediate stop $j=2,\ldots,J-1$   |
| $1-\mathrm{A}_j$ | $\mu$          |                |        | intermediate stop $j$ not served, $j=2,\ldots,J-1$                                                        |
| $\Delta_j$       | $\delta$       | $\delta_j$     | $d_j$  | earliest departure from stop $j$, actual departure time $d_j$ <br/> at intermediate stop $j=2,\ldots,J-1$ |
| $\mathrm{K}_t$   | $\kappa$       |                | $v(t)$ | collision at time $t$ with speed $v(t)$                                                                   |

```{admonition} Code reference
The reward is calculated in [envs/rewards.py](https://github.com/flatland-association/flatland-rl/blob/main/flatland/envs/rewards.py)
```
