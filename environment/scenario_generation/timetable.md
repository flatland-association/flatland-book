# Timetables

> This feature was introduced in `flatland 3.0.0`

## Background

Up until this point, the trains in **Flat**land were allowed to depart and arrive whenever they desired, the only goal was to make every train reach its destination as fast as possible. However, things are quite different in the real world. Timing and punctuality are crucial to railways. Trains have specific schedules. They are expected to depart and arrive at particular times.

This concept has been introduced to the environment in **Flat**land 3.0. Trains now have a time window within which they are expected to start and reach their destination.

## Significant Changes

### Agent

Due to the introduction of timetables, agents now have access to a set of new properties and methods, they are described below.

#### Properties:

-   **Earliest departure:** `agent.earliest_departure` specifies the earliest time step of the simulation at which the agent is allowed to depart.
-   **Latest arrival:** `agent.latest_arrival` specifies the latest time step of the simulation before or at which the agent is expected to reach it's destination.

#### Methods:
-   **`get_shortest_path(distance_map)`**: Returns a list of `Waypoint` objects indicating the shortest path to the target from the current position.

-   **`get_travel_time_on_shortest_path(distance_map)`**: Returns the amount of time needed to reach the target while travelling on the shortest path. Takes agent's speed into account.

-   **`get_time_remaining_until_latest_arrival(elapsed_steps)`**: Returns the amount of time remaining until the latest arrival time specified for the agent. Returned value is positive if there is still time until latest arrival and negative if latest arrival has passed.

-   **`get_current_delay(elapsed_steps, distance_map)`**: Returns the difference between `get_time_remaining_until_latest_arrival()` and `get_travel_time_on_shortest_path()`. The value will be positive if the expected arrival time is projected before latest arrival and negative if the expected arrival time is projected after latest arrival. This will primarily be used to provide the reward for the agent at the end of the episode and the agent hasn't reached it's target yet i.e. the agent is past its deadline anyways.