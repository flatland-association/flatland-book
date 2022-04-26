# List of provided Derived Metrics

The derived metrics listed here use the data returned by the raw level data methods to calculate useful derived metrics. In order to maintain consistency, **every derived metric is expected to return only a float**. This will become important in the context of aggregation across tests or a submission.

```{note}
Users can feel free to add their own derived metrics. It is explained in the next section.
```

These are the following metrics which can be fetched via the API. They are defined in [flatland_analysis/metrics.py]().

| Method                         | Description (Describes state at end of episode)                                                                                                                   | Range  |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `PercentageArrived`            | Get percentage of agents which have arrived at the destination                                                                                                    | [0,1]  |
| `PercentageArrivedOntime`      | Get percentage of agents which have arrived at the destination within the latest arrival time                                                                     | [0,1]  |
| `PercentageDepartedNotArrived` | Get percentage of agents which have departed but never reached their destination                                                                                  | [0,1]  |
| `PercentageNeverDeparted`      | Get percentage of agents which never left the starting point                                                                                                      | [0,1]  |
| `MeanDelayArrived`             | Get mean delay of agents which have arrived at their destinations <br> (positive delay if arrived after latest arrival and negative if the agent arrived earlier) | (-∞,∞) |
| `MinDelayArrived`              | Get min value of delay of agents which have arrived at their destinations                                                                                         | (-∞,∞) |
| `MaxDelayArrived`              | Get max value of delay of agents which have arrived at their destinations                                                                                         | (-∞,∞) |
| `MeanCurrentDelayNotArrived`   | Get mean value of the projected delay of agents which haven't arrived at their destinations yet                                                                   | (0,∞)  |
| `MinCurrentDelayNotArrived`    | Get min value of the projected delay of agents which haven't arrived at their destinations yet                                                                    | (0,∞)  |
| `MaxCurrentDelayNotArrived`    | Get max value of the projected delay of agents which haven't arrived at their destinations yet                                                                    | (0,∞)  |
| `MeanSPNeverDeparted`          | Get mean value of the length of shortest paths of agents which haven't departed yet to their destinations.                                                        | (0,∞)  |
| `MinSPNeverDeparted`           | Get min value of the length of shortest paths of agents which haven't departed yet to their destinations.                                                         | (0,∞)  |
| `MaxSPNeverDeparted`           | Get max value of the length of shortest paths of agents which haven't departed yet to their destinations.                                                         | (0,∞)  |
