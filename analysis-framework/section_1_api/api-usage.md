# How to use the API

## Fetching the data & Getting the metrics

#### 1.Fetching data

Before working with a submission ID, the data has to be fetched first; This can be accomplished using:

-   **fetch_submission_data(submission_id, actions, data)**:

    -   `submission_id`:`<str>` - submission ID for which the data should be fetched
    -   `actions`:`<bool>` - download the actions folder if True.
    -   `data`:`<bool>` - download the data folder if True.

-   **fetch_submissions(submission_ids)**:
    -   `submission_ids`:`<List<str>>` - A list of submission IDs as strings for whose data will be downloaded.

```{note}
A progress bar would appear showing the total files present within the submission log directory.
```

#### 2. Getting the metrics

After fetching the data, the following methods can be used to fetch a given list of metrics for a level, a test or a whole submission. The values of the metrics returned for the test and the submission are the mean of the values returned for the levels under them.

The **list of metrics** can contain a reference to the metric classes (for example `PercentageArrived`) or instances of the metric classes (like `PercentageArrived()`). The metrics provided by default can be passed as a class itself. Its more useful to create an instance when you define custom metrics that take in some constructor parameters which may be required for your custom metric.

-   **get_level_metrics(metrics, submission_id, test_id, level_id)**

    -   `metrics`:`<List>`
    -   `submission_id`:`<str>`
    -   `test_id`:`<int/None>`
    -   `level_id`:`<int/None>`

-   **get_test_metrics(metrics, submission_id, test_id)**

    -   `metrics`:`<List>`
    -   `submission_id`:`<str>`
    -   `test_id`:`<int/None>`

-   **get_submission_metrics(metrics, submission_id)**
    -   `metrics`:`<List>`
    -   `submission_id`:`<str>`

## Example usage:

Let's take a look at an example:

```python
from flatland_analysis.api import AnalysisFramework
from flatland_analysis.metrics import PercentageArrived, PercentageDepartedNotArrived


framework = AnalysisFramework()

framework.fetch_submission_data(submission_id="T12345")

results = framework.get_level_metrics(
    metrics = [PercentageArrived, PercentageDepartedNotArrived, DelayArrived('mean')],
    submission_id = "T12345",
    test_id = 0,
    level_id = 0
)
print(results) # type: List[float]

results = framework.get_test_metrics(
    metrics = [PercentageArrived, CurrentDelayNotArrived('max')],
    submission_id = "T12345",
    test_id = 0,
    aggregate_fn='mean'
)
print(results) # type: List[float]

results = framework.get_submission_metrics(
    metrics = [PercentageArrived, , LenSPNeverDeparted('min')],
    submission_id = "T12345",
    aggregate_fn='mean'
)
print(results) # type: List[float]
```
