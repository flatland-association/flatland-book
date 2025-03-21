Environment
===========

### Variable Speed Profiles

> This feature was introduced in [4.0.6](https://github.com/flatland-association/flatland-rl/pull/136)

#### Description

Trains can choose to run slower than permitted. This reflects core railway domain features.

In particular, trains have a speed that can be lower than the current max speed.
The simulation updates the train's speed counter accordingly. Reinterpret `DO_NOTHING` as keep running, `STOP_MOVING` as decelerate and `MOVE_FORWARD` as
accelerate.
Configuration sets the acceleration/braking delta or the old behaviour.
A penalty can be configured to reward function penalizing if a train enters a cell already occupied.

#### Changes

* Refactor `SpeedCounter` to use travelled distance instead of `max_count`.
* Support speed changes in `SpeedCounter`.
* reinterpret actions (configuration whether to keep current behaviour):
    * `MOVE_FORWARD` increase speed (delta configurable)
    * `STOP_MOVING` decrease speed (delta configurable); set to STOPPING state if speed zero is reached.
* configurable penalty if trains "crash" (if the env needs to force-stop-them), penalty proportional to train's speed.
* extract reward handling to separate (testable) class

### Multi-stop Schedules (w/o alternatives/routing flexibility)

> This feature was introduced in [4.0.5](https://github.com/flatland-association/flatland-rl/pull/124)

#### Description

Introduce intermediate targets in schedule and reward function. This reflects core railway domain features.

In particular, Flatland timetable can have several intermediate targets with time window earliest, latest.
(Negative) rewards for not serving intermediate targets or not respecting earliest/latest window can be configured.
Schedule generator can be configured with number of intermediate targets.

#### Changes

* Instead of initial position, initial direction, target, earliest_departure and latest_arrival, schedule now consists of
  list of positions, earliest departures and latest arrivals plus initial direction.
* Extract reward function from `RailEnv`
* Implement penalizing intermediate stops with three new parameters:
    - `intermediate_not_served_penalty`
    - `intermediate_late_arrival_penalty_factor`
    - `intermediate_early_departure_penalty_factor`
* Allow for line length in `sparse_line_generator` (same for all agents).

### 110 Over- and underpasses (aka. level-free diamond crossings)

> This feature was introduced in [4.0.5](https://github.com/flatland-association/flatland-rl/pull/120)

#### Description

Introduce level-free crossings. This reflects core railway domain features.

In particular, Diamond crossing can be defined to be level-free, which allows two trains to occupy the cell if one runs horizontal and the other vertical.

#### Changes

* Add list of cells which allow for level-free crossings if agents move in opposite directions.
* Add `p_level_free` in rail gen to sample percentage of level free diamond-crossings from generated diamond crossings.

