# Level Configurations

| level   | #scenarios | number of agents      | max. number of intermediate stops | properties                                                                                       | malfunctions                                    |
|---------|:----------:|-----------------------|:---------------------------------:|--------------------------------------------------------------------------------------------------|-------------------------------------------------|
| level_0 |     5      | {8,11,14,26,28}       |            {3,3,4,6,6}            | One train per Line starting at t=0                                                               | None                                            |
| level_1 |     5      | {36,50,62,118,210}    |            {3,3,4,6,6}            | Multiple trains per Line, different starting times, larger travel factor (more time for journey) | None                                            |
| level_2 |     5      | {90,125,150,300,532}  |            {3,3,4,6,6}            | More trains, tighter schedules (periodicity & travel factor)                                     | None                                            |
| level_3 |     5      | {36,50,62,118,210}    |            {3,3,4,6,6}            | Like level 1 but with                                                                            | Breakdowns                                      |
| level_4 |     5      | {90,125,150,300,532}  |            {3,3,4,6,6}            | Like level 2 but with                                                                            | Breakdowns and departure delays                 |
| level_5 |     5      | {90,125,150,300,532}  |            {3,3,4,6,6}            | Like level 4 but with more severe malfunctions (more frequent & longer)                          | Breakdowns and departure delays                 |
| level_6 |     5      | {532,532,532,532,532} |            {6,6,6,6,6}            | Full map only, progressively more malfunctions (including infrastructure disruptions)            | Breakdowns, departure delays and infrastructure |

The scenarios are generated using the flatland scenario generator (see [flatland-scenarios](https://github.com/flatland-association/flatland-scenarios/tree/main/competitions/competition_2026)). The lines and initial timetables are parametrized by hand and the rollout (i.e. generation of all timetables) is done using the script in the linked repository. The initial parameters as well as the parameters in the metadata file for the rollout are hidden from competitors. These parameters include the sequence of stations (i.e. lines), the time windows at stops (i.e. timetables with earliest departure and latest arrival) and the frequencies (i.e. the number of steps between the initial earliest departures of trains on a given line). Likewise, the
parametrization of the malfunctions is hidden in the metadata file, as is the seed for the pseudorandom occurence of malfunctions, which stays the same for all submissions to ensure fairness between different submissions.

All 28 stations are provided for participants in [*stations.pkl*](reinforcement_learning/sampling/stations.pkl). 6 lines that are used in the evaliation are also given as examples in [*level_o_scenario_1.pkl*](reinforcement_learning/sampling/level_0_scenario_1.pkl).

To generate environments for training from the given resources or to use the provided example curriculum, see [training_envs](training_envs).
