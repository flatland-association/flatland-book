Scenario Generation
===================

## Rail Generators, Line Generators and Timetable Generators

The separation between rail generation and schedule generation reflects the organisational separation in the railway domain

- Infrastructure Manager (IM): is responsible for the layout and maintenance of tracks simulated by `rail_generator`.
- Railway Undertaking (RU): operates trains on the infrastructure
  Usually, there is a third organisation, which ensures discrimination-free access to the infrastructure for concurrent requests for the infrastructure in a *
  *schedule planning phase** simulated by `line_generator` and `timetable_generator`.
  However, in the **Flat**land challenge, we focus on the re-scheduling problem during live operations. So,

We can produce `RailGenerator`s by completing the following:

```python
def sparse_rail_generator(max_num_cities=5, grid_mode=False, max_rails_between_cities=4,
                          max_rail_pairs_in_city=4, seed=0):
    def generator(width, height, num_agents, num_resets=0):
        # generate the grid and (optionally) some hints for the line_generator
        ...

        return grid_map, {'agents_hints': {
            'num_agents': num_agents,
            'city_positions': city_positions,
            'train_stations': train_stations,
            'city_orientations': city_orientations
        }}

    return generator
```

similarly, `LineGenerator`s:

```python
def sparse_line_generator(speed_ratio_map: Mapping[float, float] = None) -> LineGenerator:
    def generator(rail: GridTransitionMap, num_agents: int, hints: Any = None):
        # place agents:
        # - initial position
        # - initial direction
        # - targets
        # - speed data
        # - malfunction data
        ...

        return agents_position, agents_direction, agents_target, speeds, agents_malfunction

    return generator
```

And finally, `timetable_generator` is called within the `RailEnv`'s reset() during line generation to create a time table for the trains.

```python
def timetable_generator(agents: List[EnvAgent], distance_map: DistanceMap,
                        agents_hints: dict, np_random: RandomState = None) -> Timetable:
    # specify:
    # - earliest departures
    # - latest arrivals
    # - max episode steps
    ...

    return Timetable(earliest_departures, latest_arrivals, max_episode_steps)
```

Notice that the `rail_generator` may pass `agents_hints` to the  `line_generator` and `timetable_generator` which the latter may interpret.
For instance, the way the `sparse_rail_generator` generates the grid, it already determines the agent's goal and target.
Hence, `rail_generator`, `line_generator` and  `timetable_generator` have to match if `line_generator` presupposes some specific `agents_hints`.
Currently, the only one used are the `sparse_rail_generator`, `sparse_line_generator` and the `timetable_generator` which works in conjunction with these.

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

### Over- and underpasses (aka. level-free diamond crossings)

> This feature was introduced in [4.0.5](https://github.com/flatland-association/flatland-rl/pull/120)

#### Description

Introduce level-free crossings. This reflects core railway domain features.

In particular, Diamond crossing can be defined to be level-free, which allows two trains to occupy the cell if one runs horizontal and the other vertical.

#### Changes

* Add list of cells which allow for level-free crossings if agents move in opposite directions.
* Add `p_level_free` in rail gen to sample percentage of level free diamond-crossings from generated diamond crossings.