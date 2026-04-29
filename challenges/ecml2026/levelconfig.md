# Level Configurations

| level   | #scenarios | number of agents           | max. number of intermediate stops | properties                                                                                       | malfunctions                                    |
|---------|:----------:|----------------------------|:---------------------------------:|--------------------------------------------------------------------------------------------------|-------------------------------------------------|
| level_0 |     5      | {8,11,14,26,28}​            | {3,3,4,6,6}                       | One train per Line starting at t=0                                                               | None                                            |
| level_1 |     5      | {36,50,62,118,210}         | {3,3,4,6,6}                       | Multiple trains per Line, different starting times, larger travel factor (more time for journey) | None                                            |
| level_2 |     5      | {90,125,150,300,532}​       | {3,3,4,6,6}                       | More trains, tighter schedules (periodicity & travel factor)                                     | None                                            |
| level_3 |     5      | {36,50,62,118,210}         | {3,3,4,6,6}                       | Like level 1 but with                                                                            | Breakdowns                                      |
| level_4 |     5      | {90,125,150,300,532}​       | {3,3,4,6,6}                       | Like level 2 but with                                                                            | Breakdowns and departure delays                 |
| level_5 |     5      | {90,125,150,300,532}​       | {3,3,4,6,6}                       | Like level 4 but with more severe malfunctions (more frequent & longer)​                          | Breakdowns and departure delays                 |
| level_6 |     5      | {532,532,532,532,532}​      | {6,6,6,6,6}                       | Full map only, progressively more malfunctions (including infrastructure disruptions)            | Breakdowns, departure delays and infrastructure |

