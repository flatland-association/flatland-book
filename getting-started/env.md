The Flatland Environment
===

Let's go through the mains Flatland concepts: actions, observations and predictors.

Actions in Flatland
---

Flatland is a railway simulation. Thus the actions of an agent are strongly limited to the railway network. This means that in many cases not all actions are valid.

The possible actions of an agent are
- 0 *Do Nothing*:  If the agent is moving it continues moving, if it is stopped it stays stopped
- 1 *Deviate Left*: This action is only valid at cells where the agent can change direction towards left. If action is chosen, the left transition and a rotation of the agent orientation to the left is executed. If the agent is stopped at any position, this action will cause it to start moving in any cell where forward or left is allowed!
- 2 *Go Forward*: This action will start the agent when stopped. At switches this will chose the forward direction.
- 3 *Deviate Right*: Exactly the same as deviate left but for right turns.
- 4 *Stop*: This action causes the agent to stop, this is necessary to avoid conflicts in multi agent setups (Not needed for navigation).

Shortest path predictor
---

With multiple agents a lot of conflicts will arise on the railway network. These conflicts arise because different agents want to occupy the same cells at the same time. Due to the nature of the railway network and the dynamic of the railway agents (they can't turn around!), the conflicts have to be detected in advance in order to avoid them. If agents are facing each other and don't have any options to deviate from their path it is called a *deadlock* ❌.

Therefore we introduce a simple prediction function that predicts the most likely (here shortest) path of all the agents. Furthermore, the prediction is withdrawn if an agent stops and replaced by a prediction that the agent will stay put. The predictions allow the agents to detect possible conflicts before they happen and thus perform counter-measures.

```{info}
This is a very basic implementation of a predictor. It will not solve all the problems because it always predicts shortest paths and not alternative routes. It is up to you to come up with much more clever predictors to avoid conflicts!
```

Tree Observation
---

Flatland offers three basic observations out of the box. We encourage you to develop your own observations that are better suited for this specific task.

For the navigation training we start with the Tree Observation as agents will learn the task very quickly using this observation.
The tree observation exploits the fact that a railway network is a graph and thus the observation is only built along allowed transitions in the graph.

Here is a small example of a railway network with an agent in the top left corner. The tree observation is build by following the allowed transitions for that agent.

![Small_Network](https://i.imgur.com/utqMx08.png)

As we move along the allowed transitions we build up a tree where a new node is created at every cell where the agent has different possibilities (Switch), dead-end or the target is reached.
It is important to note that the tree observation is always build according to the orientation of the agent at a given node. This means that each node always has 4 branches coming from it in the directions *Left, Forward, Right and Backward*. These are illustrated with different colors in the figure below. The tree is build form the example rail above. Nodes where there are no possibilities are filled with `-inf` and are not all shown here for simplicity. The tree however, always has the same number of nodes for a given tree depth.

![Tree_Observation](https://i.imgur.com/VsUQOQz.png)

Node Information
---

Each node is filled with information gathered along the path to the node. Currently each node contains 9 features:

- 1: if own target lies on the explored branch the current distance from the agent in number of cells is stored.

- 2: if another agents target is detected the distance in number of cells from current agent position is stored.

- 3: if another agent is detected the distance in number of cells from current agent position is stored.

- 4: possible conflict detected (This only works when we use a predictor and will not be important in this tutorial)

- 5: if an not usable switch (for agent) is detected we store the distance. An unusable switch is a switch where the agent does not have any choice of path, but other agents coming from different directions might. 

- 6: This feature stores the distance (in number of cells) to the next node (e.g. switch or target or dead-end)

- 7: minimum remaining travel distance from node to the agent's target given the direction of the agent if this path is chosen

- 8: agent in the same direction found on path to node
    - n = number of agents present same direction (possible future use: number of other agents in the same direction in this branch)
    - 0 = no agent present same direction

- 9: agent in the opposite direction on path to node
    - n = number of agents present other direction than myself
    - 0 = no agent present other direction than myself

For training purposes the tree is flattened into a single array.