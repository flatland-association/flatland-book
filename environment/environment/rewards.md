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

is the sum of all rewards $g_i$ of agent $i$. The reward $g_i$ of an agent consists of a reward at the end of the episode as well as at each timestep $t.$
Per-timestep rewards only consist of a penalty if the train crashes, i.e., collides with another train that occupies the same cell. The collision penalty is
proportional to the current speed $v(t)$ of the train. The reward $g_i$ of an agent $i$ is

```math
\begin{align}
g_i = &
% delay at target:
\underbrace{\mathrm{A}_J \cdot  \min \{\alpha_J - a_J,0\}}_{\text{delay at target}}  
% journey not started:
+ \underbrace{(1 - \Delta_1) \cdot \phi \cdot (p + \pi)}_{\text{journey not started}}
% target not reached:
+ \underbrace{(1 - \mathrm{A}_J) \cdot (-d)}_{\text{target not reached}}\\
& + \sum_{j=2}^{J-1} \Big[
% intermediate late arrival
\underbrace{\mathrm{A}_j \cdot \alpha \cdot \min \{\alpha_j - a_j,0\}}_{\text{late arrival}}
% intermediate stop not served
+ \underbrace{(1 - \mathrm{A}_j) \cdot \mu \cdot (-1)}_{\text{stop not served}}
% intermediate early departure
+ \underbrace{\Delta_j \cdot \delta \cdot \min \{ d_j - \delta_j, 0 \}}_{\text{early departure}} \Big] \\
% collision
& + \sum_{t=1}^T  \underbrace{\mathrm{K}_t \cdot \kappa \cdot (- v(t))}_{\text{collision}} \ ,
\end{align}
```

where $J$ is the number of stops (including the departure at the start, as well as the target) and $T$ is the number of timesteps of the episode.
The symbols are described in Table~\ref{tab:events}.

|                              | penalty factor <br/>($\geq 0$) | event <br/> $\in \{0,1\}$ | scheduled  | actual | description                                                                                               |
|:-----------------------------|--------------------------------|---------------------------|------------|--------|-----------------------------------------------------------------------------------------------------------|
| delay at target              | 1                              | $\mathrm{A}_J$            | $\alpha_J$ | $a_J$  | $\mathrm{A}_J$ latest arrival and $a_J$ actual arrival at target $J$                                      |
| journey not started          | $\phi$, $\pi$                  | $1-\Delta_1$              |            | $p$    | cancellation factor $\phi$ and buffer $\pi$,    <br/> $p$ is the shortest path from start to target       |
| target not reached           | 1                              | $1-\mathrm{A}_J$          |            | $d$    | time $d$ remaining on shortest path towards target                                                        |
| intermediate late arrival    | $\alpha$                       | $\mathrm{A}_j$            | $\alpha_j$ | $a_j$  | latest arrival $\mathrm{A}_j$, actual arrival time $a_j$    <br/> at intermediate stop $j=2,\ldots,J-1$   |
| intermediate stop not served | $\mu$                          | $1-\mathrm{A}_j$          |            |        | intermediate stop $j$ not served, $j=2,\ldots,J-1$                                                        |
| intermediate early departure | $\delta$                       | $\Delta_j$                | $\delta_j$ | $d_j$  | earliest departure from stop $j$, actual departure time $d_j$ <br/> at intermediate stop $j=2,\ldots,J-1$ |
| collision                    | $\kappa$                       | $\mathrm{K}_t$            |            | $v(t)$ | collision at time $t$ with speed $v(t)$                                                                   |

Note that the simulation enforces that agents cannot start earlier than $\delta_1$ at their start. On the other hand, early departure at intermediate stops is
not enforced by the simulation, but will be penalized by the rewards function.
Also note that order of intermediate stops is also not enforced by the simulation in case of overlapping time windows.

```{admonition} Code reference
The reward is calculated in [envs/rewards.py](https://github.com/flatland-association/flatland-rl/blob/main/flatland/envs/rewards.py)
```
