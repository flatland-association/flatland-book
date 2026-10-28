Provided Observations
===

In Flatland, you have full control over the observations that your agents will work with. Three observations are provided as starting point. However, you are
encouraged to implement your own.

The three provided observations are:

- [Global observation](#global-observation)
- [Local grid observation](#local-grid-observation)
- [Tree observation](#tree-observation)

![stock observations](https://i.imgur.com/oo8EIYv.png)

***Global, local and tree:** A visual summary of the three provided observations.*

Global observation
---

The global observation is the simplest one. In this case, every agent is provided a global view of the full Flatland environment. This can be compared to the
full, raw-pixel data used in Atari games. The observation of each agent is a tuple of three arrays of size `h × w × c`, where `h` is the height of the
environment, `w` is the width of the environment and `c` is the number of channels of the array. These channels can be modified by the participants but in the
initial configuration, the tuple `(transition maps, agent states, agent targets)` contains:

- **Transition maps:** provides a unique value for each type of transition map and its orientation. Its dimensions is `h × w × 16` assuming 16 bits encoding of
  transitions. Transition maps represent the movements allowed on a cell, [read more about them here](../environment/transitions.ipynb).

- **Agent states:** A 3D array `h × w × 5` containing:
    - **Channel 0:** direction of the self agent at its position (at its initial position before departure)
    - **Channel 1:** other agents' positions and direction
    - **Channel 2:** self and other agents' malfunctions
    - **Channel 3:** self and other agents' fractional speeds
    - **Channel 4:** number of agents (including the self agent) not yet departed from that initial position

  Channels 0 to 3 are `-1` where there is no agent, channel 4 is `0`.

- **Agent targets:** A 3D arrays `h × w × 2` containing respectively the position of the current agent target, and the positions of the other agents' targets.
  The positions of the targets of the other agents is a simple `0`/`1` flag, therefore this observation doesn't indicate where each other agent is heading to.

This observation space is well suited for single-agent navigation but does not provide enough information to solve the multi-agent navigation task, thus
participants must improve on this observation space to solve the challenge.

```{admonition} Code reference
This observation is defined in [flatland.envs.observations.GlobalObsForRailEnv](https://github.com/flatland-association/flatland-rl/blob/v4.3.0/flatland/envs/observations.py#L528)
```

Local grid observation
---

```{warning}
The local grid observation has shown limited experimental results and is considered deprecated. We keep it for historical purpose, and because it may be useful when combined with other observations. Be aware that its implementation is not currently supported.  
```

The local grid observation is similar to the global observation, but restricted to a rectangular field of view of `view_height × (2 · view_width + 1)` cells,
configured by the constructor parameters `view_width`, `view_height` and `center`. The field of view is rotated according to the agent’s direction: the agent
is situated at the position `(center, view_width)` within the observation grid, and the rows beyond it lie in front of the agent. With `center=0`, the agent
only observes the cells in front of it.

The observation is a tuple containing:

- **Transition maps:** `view_height × (2 · view_width + 1) × 16`, as in the global observation.
- **Agent targets:** `view_height × (2 · view_width + 1) × 2`, the position of the agent's own target and the positions of the other agents' targets, if in view.
- **Other agents:** `view_height × (2 · view_width + 1) × 4`, the one-hot direction of the other agents at their positions, if in view.
- **Direction:** the one-hot direction of the agent itself (4 elements).

This observation space offers benefits over the global view, mostly by reducing the amount of irrelevant information in the observation space. However, it
gives no information about the target location when the target is outside of view. Also, it is only defined for agents on the map: for an agent that has not
departed yet, `get()` fails.

<img width="500" src="https://drive.google.com/uc?export=view&id=1kZzinMOs7hlPaSJJeIiaQ7lAz2erXuHx">

***An abstract visualization of the local field of view of an agent.** The green boxes represent visible cells in the agents field of view. This field of view
is turned as the agent’s direction changes.*

```{admonition} Code reference
This observation is defined in [flatland.envs.observations.LocalObsForRailEnv](https://github.com/flatland-association/flatland-rl/blob/v4.3.0/flatland/envs/observations.py#L605)
```

Tree observation
---

The tree observation exploits the fact that a railway network is a graph and thus the observation is only built along allowed transitions in the graph. The
observation is generated by spanning a 4 branched tree from the current position of the agent. Each branch follows the allowed transitions (backward branch only
allowed at dead-ends) until a cell with multiple allowed transitions is reached. Here the information gathered along the branch is stored as a node in the tree.

Here is a small example of a railway network with an agent in the top left corner. The tree observation is build by following the allowed transitions for that
agent:

![Small_Network](https://i.imgur.com/utqMx08.png)

As we move along the allowed transitions we build up a tree where a new node is created at every cell where the agent has different possibilities (Switch),
dead-end or the target is reached.

It is important to note that the tree observation is always build according to the orientation of the agent at a given node. This means that each node always
has 4 branches coming from it in the directions *Left, Forward, Right and Backward*. These are illustrated with different colors in the figure below. The tree
is build form the example rail above. Nodes where there are no possibilities are filled with `-inf` and are not all shown here for simplicity. The tree however,
always has the same number of nodes for a given tree depth.

![Tree_Observation](https://i.imgur.com/VsUQOQz.png)

Each node is filled with information gathered along the path to the node. Currently each node contains 12 features:

- **Channel 0:** if own target lies on the explored branch the current distance from the agent in number of cells is stored.
- **Channel 1:** if another agents target is detected the distance in number of cells from current agent position is stored.
- **Channel 2:** if another agent is detected the distance in number of cells from current agent position is stored.
- **Channel 3:** possible conflict detected - this relies on a **predictor** that we will introduce afterward
    - tot_dist = Other agent predicts to pass along this cell at the same time as the agent, we store the distance in number of cells from current agent
      position
    - 0 = No other agent reserve the same cell at similar time
- **Channel 4:** if an not usable switch (for agent) is detected we store the distance. An unusable switch is a switch where the agent does not have any choice
  of path (ie the agent is blocked), but other agents coming from different directions might.
- **Channel 5:** This feature stores the distance (in number of cells) to the next node (e.g. switch or target or dead-end)
- **Channel 6:** minimum remaining travel distance from node to the agent's target given the direction of the agent if this path is chosen
- **Channel 7:** number of agents going in the same direction found on path to node
- **Channel 8:** number of agents going in the opposite direction found on path to node
- **Channel 9:** malfunctioning/blocking agents, returns the number of time steps the observed agent will remain blocked
- **Channel 10:** slowest observed speed of an agent in same direction
    - 1 if no agent is observed
    - min_fractional speed otherwise
- **Channel 11:** number of agents ready to depart but no yet active

Missing values are handled as follow:

- Missing/padding nodes are filled in with `-inf`.
- Missing values in present node are filled in with `+inf`.

Special cases:

- In case of the root node, the values are `[0, 0, 0, 0, distance from agent to target, own malfunction, own speed]`
- In case the target node is reached, the values are `[0, 0, 0, 0, 0]`.

```{admonition} Code reference
This observation is defined in [flatland.envs.observations.TreeObsForRailEnv](https://github.com/flatland-association/flatland-rl/blob/v4.3.0/flatland/envs/observations.py#L34)
```

Notice how **channel 3** indicates if a possible conflict is detected. In order to predict conflicts, the tree observation relies on a predictor, which
anticipates where agents will be in the future. We provide a stock predictor that assumes each agent just travels along its shortest path. We
will [talk in more details about predictors](custom_observations.md) when introducing custom observations. 