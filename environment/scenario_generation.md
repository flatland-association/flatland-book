Scenario Generation
===================


## Rail Generators, Line Generators and Timetable Generators
The separation between rail generation and schedule generation reflects the organisational separation in the railway domain
- Infrastructure Manager (IM): is responsible for the layout and maintenance of tracks simulated by `rail_generator`.
- Railway Undertaking (RU): operates trains on the infrastructure
  Usually, there is a third organisation, which ensures discrimination-free access to the infrastructure for concurrent requests for the infrastructure in a **schedule planning phase** simulated by `line_generator` and `timetable_generator`.
  However, in the **Flat**land challenge, we focus on the re-scheduling problem during live operations. So,

Technically `rail_generator`, `line_generator` and the `timetable_generator` are implemented as follows
```python
RailGeneratorProduct = Tuple[GridTransitionMap, Optional[Any]]
RailGenerator = Callable[[int, int, int, int], RailGeneratorProduct]

AgentPosition = Tuple[int, int]

Line = collections.namedtuple('Line',  [('agent_positions', IntVector2DArray),
                                        ('agent_directions', List[Grid4TransitionsEnum]),
                                        ('agent_targets', IntVector2DArray),
                                        ('agent_speeds', List[float]),
                                        ('agent_malfunction_rates', List[int])])

LineGenerator = Callable[[GridTransitionMap, int, Optional[Any], Optional[int]], Line]

Timetable = collections.namedtuple('Timetable',  [('earliest_departures', List[int]),
                                                  ('latest_arrivals', List[int]),
                                                  ('max_episode_steps', int)])

timetable_generator = Callable[[List[EnvAgent], DistanceMap, dict, RandomState], Timetable]
```
