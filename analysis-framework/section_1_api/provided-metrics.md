# List of provided Derived Metrics

The derived metrics listed here use the data returned by the raw level data methods to calculate useful derived metrics. In order to maintain consistency, **every derived metric is expected to return only a float**. This will become important in the context of aggregation across tests or a submission.

```{note}
Users can feel free to add their own derived metrics. It is explained in the next section.
```

These are the following metrics which can be fetched via the API. They are defined in [flatland_analysis/metrics.py]().

The following classes do not require an init parameters.

They can be used like so:

```python
results = framework.get_level_metrics(
    metrics = [PercentageArrived, PercentageArrivedOntime],
    submission_id = "T12345",
    test_id = 0,
    level_id = 0
)
```

| Method                         | Description (Describes state at end of episode)                                               | Range |
| ------------------------------ | --------------------------------------------------------------------------------------------- | ----- |
| `PercentageArrived`            | Get percentage of agents which have arrived at the destination                                | [0,1] |
| `PercentageArrivedOntime`      | Get percentage of agents which have arrived at the destination within the latest arrival time | [0,1] |
| `PercentageDepartedNotArrived` | Get percentage of agents which have departed but never reached their destination              | [0,1] |
| `PercentageNeverDeparted`      | Get percentage of agents which never left the starting point                                  | [0,1] |

For the following metric classes, an init parameter has to provided. The possible values for the init param are:

-   `"mean"`: returns the mean of the metric in the particular level.
-   `"min"`: returns the min of the metric in the particular level.
-   `"max"`: returns the max of the metric in the particular level.
-   `callable(list) -> float`: a custom function that takes in an input list, performs some aggregation on it and returns a float.

They can be used in the following way:

```python
results = framework.get_level_metrics(
    metrics = [DelayArrived('mean'), CurrentDelayNotArrived(lambda metrics: float(max(metrics)))],
    submission_id = "T12345",
    test_id = 0,
    level_id = 0
)
```

| Method                   | Description (Describes state at end of episode)                                                                                                                               | Range  |
| ------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `DelayArrived`           | Get mean / min / max delay of agents which have arrived at their destinations <br> (positive delay if arrived after latest arrival and negative if the agent arrived earlier) | (-∞,∞) |
| `CurrentDelayNotArrived` | Get mean / min / max value of the projected delay of agents which haven't arrived at their destinations yet                                                                   | (0,∞)  |
| `LenSPNeverDeparted`     | Get mean / min/ max value of the length of shortest paths of agents which haven't departed yet to their destinations.                                                         | (0,∞)  |
