Environment information
=======================

When building your custom observation builder, you might want to aggregate and define your own features that are different from the raw environment data. In this section we introduce how such information can be accessed and how you can build your own features out of them.

Transitions maps
----------------

The transition maps build the base for all movements in the environment. They contain all the information about allowed transitions for the agent at any given position. Because railway movement is limited to the railway tracks, these are important features for any controller that wants to interact with the environment. 

```{admonition} Code reference
All functionality and features of transition maps can be found in [core/transition_map.py](https://gitlab.aicrowd.com/flatland/flatland/blob/master/flatland/core/transition_map.py).
```

There are two different possibilities to access the possible transitions at any given cell:

### get_transitions()

Provide a cell position and an orientation (usually the orientation of the agent) and call `env.rail.get_transitions(*position, direction)`. In return, you get will a 4D vector with the transition probability ordered as [North, East, South, West] given the initial orientation.

The position is a tuple of the form `(x, y)` where $x \in [0, h]$ and $y \in [0, w]$ with $h$ and $w$ the height and width of the environment. This can be used for branching in a tree search and when looking for all possible allowed paths of an agent as it will provide a simple way to get the possible trajectories.

### get_full_transitions()
    
When more detailed information about the cell is necessary, you can also get the **full** transitions of a cell by calling `env.rail.get_full_transitions(*position)`. This will return an `int16` for the cell representing the allowed transitions. 

To understand the transitions returned it is best to represent it as a binary number `bin(transition_int)`, where the bits have to following meaning: NN NE NS NW EN EE ES EW SN SE SS SW WN WE WS WW. 

For example, the binary code 1000 0000 0010 0000, represents a straight where an agent facing north can transition north and an agent facing south can transition south and no other transitions are possible. 

To get a better feeling of what the binary representations of the elements look like, check the special cases of `GridTransitions` in [`RailEnvTransitions`](https://gitlab.aicrowd.com/flatland/flatland/blob/master/flatland/core/grid/rail_env_grid.py#L28). They are the set of transitions mimicking the types of real Swiss rail connections:

```python
transition_list = [int('0000000000000000', 2),  # empty cell - Case 0
                   int('1000000000100000', 2),  # Case 1 - straight
                   int('1001001000100000', 2),  # Case 2 - simple switch
                   int('1000010000100001', 2),  # Case 3 - diamond drossing
                   int('1001011000100001', 2),  # Case 4 - single slip
                   int('1100110000110011', 2),  # Case 5 - double slip
                   int('0101001000000010', 2),  # Case 6 - symmetrical
                   int('0010000000000000', 2),  # Case 7 - dead end
                   int('0100000000000010', 2),  # Case 1b (8)  - simple turn right
                   int('0001001000000000', 2),  # Case 1c (9)  - simple turn left
                   int('1100000000100010', 2)]  # Case 2b (10) - simple switch mirrored
```

These two objects can be used for example to detect switches that are usable by other agents, but not the observing agent itself. This can be an important feature when actions have to be taken in order to avoid conflicts.

```python
cell_transitions = self.env.rail.get_transitions(*position, direction)
transition_bit = bin(self.env.rail.get_full_transitions(*position))

total_transitions = transition_bit.count("1")
num_transitions = np.count_nonzero(cell_transitions)

# Detect Switches that can only be used by other agents.
if total_transitions > 2 > num_transitions:
    unusable_switch_detected = True
```

Agent information
-----------------

The agents are represented as an agent class and are provided when the environment is instantiated. Because agents can have different properties it is helpful to know how to access this information. 

You can simply access the three main types of agent information in the following ways `agent = env.agents[handle]`

### Agent basic information 

All the agent in the initiated environment can be found in the env.agents class. Given the index of the agent you have access to:
-   **Agent position:** `agent.position` which returns the current coordinates (x, y) of the agent.
-   **Agent target:** `agent.target` which returns the target coordinates (x, y).
-   **Agent direction:** `agent.direction` which is an int representing the current orientation {0: North, 1: East, 2: South, 3: West}
-   **Agent moving:** `agent.moving` where 0 means the agent is currently not moving and 1 indicates agent is moving.

### Agent timetable information 

In **Flat**land 3, agents have a time window within which they must start and reach their destination. The following properties specify the time window:
-   **Earliest departure:** `agent.earliest_departure` specifies the earliest time step of the simulation at which the agent is allowed to depart.
-   **Latest arrival:** `agent.latest_arrival` specifies the latest time step of the simulation before or at which the agent is expected to reach it's destination.

### Agent malfunction information

Similar to the speed data you can also access individual data about the
malfunctions of an agent. All data is available through
agent.malfunction_data with:

- **`malfunction`:** Indication how long the agent is still malfunctioning by an integer counting down at each time step. `0` means the agent is ok and can move.
- **`malfunction_rate`:** Poisson rate at which malfunctions happen for this agent
- **`next_malfunction`:** Number of steps until next malfunction will occur
- **`nr_malfunctions`:** Number of malfunctions an agent have occurred for this agent so far

### Agent speed information

<!-- ```{note}
Speed profiles are not used in the first round of the NeurIPS 2020 challenge.
``` -->

Beyond the basic agent information we can also access more details about
the agents type by looking at speed data:

-   **Agent max speed:** agent.speed_data["speed"] wich defines the traveling speed when the agent is moving.
-   **Agent position fraction:** `agent.speed_data["position_fraction"]` which is a number between 0 and 1 and indicates when the move to the next cell will occur. Each speed of an agent is 1 or a smaller fraction. At each env.step() the agent moves at its fractional speed forwards and only changes to the next cell when the cumulated fractions are `agent.speed_data["position_fraction"] >= 1`.
-   Agent can move at different speed which can be set up by modifying the agent.speed_data within the schedule_generator.



