Agents
======


Agent information
-----------------

The agents are represented as an agent class and are provided when the environment is instantiated. Because agents can have different properties it is helpful
to know how to access this information.

You can simply access the three main types of agent information in the following ways `agent = env.agents[handle]`

### Agent basic information

All the agent in the initiated environment can be found in the env.agents class. Given the index of the agent you have access to:

- **Agent position:** `agent.position` which returns the current coordinates (x, y) of the agent.
- **Agent target:** `agent.target` which returns the target coordinates (x, y).
- **Agent direction:** `agent.direction` which is an int representing the current orientation {0: North, 1: East, 2: South, 3: West}
- **Agent moving:** `agent.state` is the state of the agent's state machine, when moving, `agent.state == TrainState.MOVING` indicates that the train in
  currently on the map and moving.

### Agent timetable information

In **Flat**land 3, agents have a time window within which they must start and reach their destination. The following properties specify the time window:

- **Earliest departure:** `agent.earliest_departure` specifies the earliest time step of the simulation at which the agent is allowed to depart.
- **Latest arrival:** `agent.latest_arrival` specifies the latest time step of the simulation before or at which the agent is expected to reach it's
  destination.

### Agent malfunction information

Similar to the speed data you can also access individual data about the
malfunctions of an agent. All data is available through
`agent.malfunction_handler` with:

- **`malfunction_down_counter`:** Indication how long the agent is still malfunctioning by an integer counting down at each time step. `0` means the agent is ok
  and can move.
- **`num_malfunctions`:** Number of malfunctions an agent have occurred for this agent so far

### Agent speed information

Beyond the basic agent information we can also access more details about
the agents type by looking at `agent.speed_counter`:

- **Agent speed:** `agent.speed_counter.speed` wich defines the traveling speed when the agent is moving.
- **Agent speed counter:** When the speed of an agent is fractional, the agent stays in the same cell for more than one step, specifically for
  `agent.speed_counter.max_count + 1` number of steps. The value `agent.speed_counter.counter` indicates when the move to the next cell will occur, this number
  is 0 indexed. When this value reaches the value of `agent.speed_counter.max_counter`, the agent can exit the cell to the next one. At each `env.step` the
  agent increments its speed counter if the agent state is moving.
- `agent.speed_counter.is_cell_entry` indicates whether the agent just entered the cell and `agent.speed_counter.is_cell_exit` indicates the agent can exit the
  cell next step.

### State Machine

Flatland 3 introducted a state machine for the every agent that controls the behavior of the agent depending on the current state.

The possible states are `WAITING`, `READY_TO_DEPART`, `MALFUNCTION_OFF_MAP`, `MOVING`, `STOPPED`, `MALFUNCTION`, and `DONE`.

Detailed descriptions of the states and the transitions in the state machine can be found in
the [state machine subsection](https://flatland.aicrowd.com/environment/state_machine.html).


