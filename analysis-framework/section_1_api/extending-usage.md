# Extending the API's functionality

This section describes how to extend the API's functionality by defining custom metrics.

For the most part, to define the custom metrics, you will need the raw agent information which is logged. Refer [here](analysis-framework/section_1_api/provided-raw-info) for the list of available raw data.

## Example:

For example let's define a metric that returns the percentage of agents which are moving.

We will need access to the flatland's states as well.

```python
import numpy as np

from flatland_analysis.api import AnalysisFramework
from flatland_analysis.metrics import BaseMetric
from flatland.envs.step_utils.states import TrainState  # fetch the TrainState class to check if the state of agent is MOVING


class PercentageMoving(BaseMetric):
    def compute() -> float: # Notice how the metric must only return a float, so the aggregate_data method can work seamlessly
        agent_states = self.level.get_agent_states()
        return ((np.array(agent_states) == TrainState.MOVING).sum()) / len(agent_states)


framework = AnalysisFramework()

framework.fetch_submission_data(submission_id="T12345")

results = framework.get_level_metrics(
    metrics = [PercentageMoving],
    submission_id = "T12345",
    test_id = 0,
    level_id = 0
)
print(results) # type: List[float]
```
