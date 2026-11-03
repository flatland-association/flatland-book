# Design by Contract

Design by contract specifies a routine by its preconditions (what holds before it runs), its postconditions (what it guarantees afterwards) and its
invariants (what holds before and after every call). Since `flatland 5.0.0`, `RailEnv.step()` follows such a contract: the new entry points, speed and
distance of each agent are a function of its pre-step values, its action and the conflict resolution between all agents. This page summarizes what you can
rely on in each step. The steps (1)-(15) refer to the [Runtime View RailEnv Step](key_concepts). The branch-by-branch contract of the implementation is in
[design_by_contract.md](https://github.com/flatland-association/flatland-rl/blob/main/design_by_contract.md) in flatland-rl.

## Invariants

The following holds for every agent before and after every `step()`:

| invariant                    | description                                                                                                                                                                                           |
|------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| off map or on map            | `agent.current_entry_point` and `agent.next_entry_point` are both `None` (off map), or both set, and the next entry point is a successor of the current one (`env.rail.is_successor(current, next)`). |
| speed and distance           | `agent.speed_counter.speed` and `agent.speed_counter.distance` are `None` exactly when the agent is off map (`agent.current_entry_point is None`).                                                    |
| mutually exclusive resources | No two agents on the map hold the same resource (`env.resource_map.get_resource(current_entry_point, next_entry_point)`).                                                                             |
| done                         | An agent is done exactly when `agent.target_entry_point is not None`. It is set once, in the step the agent reaches one of its targets, and never changes afterwards.                                 |

## Preconditions

`step()` derives the following terms for each agent from its pre-step values and its action, after the malfunction counter update (1) and the new
malfunctions (2). Speed and distance are fractions of the cell length 1.

| term                 | definition                                                                                                                                                                                        |
|----------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `done`               | `agent.target_entry_point is not None`                                                                                                                                                            |
| `in_malfunction`     | `agent.malfunction_handler.in_malfunction`, i.e. the malfunction counter is greater than 0                                                                                                        |
| `off_map`            | `agent.current_entry_point is None`                                                                                                                                                               |
| `transition_invalid` | `env.rail.apply_action_independent(action, entry_point)` is `None`, where `entry_point` is the next entry point, or the initial entry point while off map. Missing actions count as `DO_NOTHING`. |
| `cell_exit`          | on map, `speed > 0` and `distance + speed >= 1`: the agent reaches the end of its cell in this step                                                                                               |
| `target_reached`     | on map, `cell_exit` and the next entry point is one of `agent.targets`                                                                                                                            |
| `ready_to_depart`    | not `done` and `agent.earliest_departure` is at most the number of this step (the first step is 1)                                                                                                |
| `map_entry`          | `off_map`, `ready_to_depart`, a moving action (`MOVE_LEFT`, `MOVE_FORWARD` or `MOVE_RIGHT`) and not `transition_invalid`                                                                          |
| `stopped`            | `speed == 0`                                                                                                                                                                                      |

## Collect phase: candidates

In the collect phase (3)-(7), each agent proposes a candidate for its entry points, speed and distance, from its own pre-step values only. Exactly one of
the following cases applies (in this order of precedence):

| case                        | condition                                | candidate entry points (current, next)              | candidate speed                      | candidate distance                                                   |
|-----------------------------|------------------------------------------|-----------------------------------------------------|--------------------------------------|----------------------------------------------------------------------|
| done                        | `done`                                   | unchanged                                           | 0                                    | `min(distance + speed, 1)` (`None` if removed)                       |
| target reached              | `target_reached`                         | (next entry point, its successor for the action)    | 0                                    | `None` if `remove_agents_at_target`, else `min(distance + speed, 1)` |
| malfunction                 | `in_malfunction`                         | unchanged                                           | 0                                    | unchanged                                                            |
| map entry                   | `map_entry`                              | (initial entry point, its successor for the action) | `min(acceleration_delta, max_speed)` | 0                                                                    |
| stay off map                | `off_map` and not `map_entry`            | (`None`, `None`)                                    | 0, set to `None` when accepted       | `None`                                                               |
| invalid action at cell exit | `cell_exit` and `transition_invalid`     | unchanged: the transition is denied                 | 0                                    | `min(distance + speed, 1)`: the agent waits at the end of the cell   |
| cell transition             | `cell_exit` and not `transition_invalid` | (next entry point, its successor for the action)    | by action, see below                 | `(distance + speed) mod 1`                                           |
| mid-cell                    | on map and not `cell_exit`               | unchanged                                           | by action, see below                 | `distance + speed`                                                   |

In the last two cases, the candidate speed depends on the action:

| action                                                        | candidate speed                              |
|---------------------------------------------------------------|----------------------------------------------|
| `MOVE_FORWARD`, or any moving action while `stopped`          | `min(speed + acceleration_delta, max_speed)` |
| `STOP_MOVING`                                                 | `max(speed + braking_delta, 0)`              |
| `DO_NOTHING`, or `MOVE_LEFT`/`MOVE_RIGHT` while not `stopped` | `speed`                                      |

The distance always advances by the pre-step speed: a speed change acts from the next step on. A `stopped` agent given a moving action gets its speed in
this step and moves from the next step on. Since `cell_exit` requires `speed > 0`, a `stopped` agent at the end of its cell never falls into "invalid action
at cell exit": it is promoted optimistically, and the crossing is only tried, and possibly denied, in the next step.

## Distribute phase: candidates accepted or discarded

The resource check (10) resolves the conflicts between all candidates. In the distribute phase (11)-(13), each agent's candidate is then accepted or
discarded:

| case              | condition                                                                          | entry points               | speed              | distance                   |
|-------------------|------------------------------------------------------------------------------------|----------------------------|--------------------|----------------------------|
| accepted, on map  | granted, and the candidate is on map and not a target that the agent is removed at | candidate                  | candidate          | candidate                  |
| accepted, off map | granted, and the candidate is off map, or a target with `remove_agents_at_target`  | (`None`, `None`)           | `None`             | `None`                     |
| denied crossing   | not granted, on map                                                                | unchanged                  | 0                  | `min(distance + speed, 1)` |
| denied map entry  | not granted, off map                                                               | unchanged (`None`, `None`) | unchanged (`None`) | unchanged (`None`)         |

An agent that stays within its cell is always granted. A denied agent waits at the end of its cell with speed 0 and has to accelerate again.
Once accepted, `handle_done_state` (14) sets `agent.target_entry_point` if the agent has reached a target, and removes the agent from the map if
`remove_agents_at_target` is set.
