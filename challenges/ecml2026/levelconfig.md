# Level Configurations

| level   | #scenarios | properties                                                                                       | malfunctions                                    |
|---------|:----------:|--------------------------------------------------------------------------------------------------|-------------------------------------------------|
| level_0 |     5      | One train per Line starting at t=0                                                               | None                                            |
| level_1 |     5      | Multiple trains per Line, different starting times, larger travel factor (more time for journey) | None                                            |
| level_2 |     5      | More trains, tighter schedules (periodicity & travel factor)                                     | None                                            |
| level_3 |     5      | Like level 1 but with                                                                            | Breakdowns                                      |
| level_4 |     5      | Like level 2 but with                                                                            | Breakdowns and departure delays                 |
| level_5 |     5      | Like level 4 but with more severe malfunctions (more frequent & longer)                          | Breakdowns and departure delays                 |
| level_6 |     5      | Full map only, progressively more malfunctions (including infrastructure disruptions)            | Breakdowns, departure delays and infrastructure |

