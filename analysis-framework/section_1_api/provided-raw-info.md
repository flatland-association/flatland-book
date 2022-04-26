# List of provided raw data

These are the different types of logged data which are provided by the API. They are logged while running the environment simulation and most derived metrics will be derived from them. Therefore they are useful in extending the API's functionality while defining your own custom derived metrics.

```{note}
All the raw data methods return lists, with each index in the list corresponding to the particular agent index.
```

| Method                          | Description                                                                                                           | Return Type |
| ------------------------------- | --------------------------------------------------------------------------------------------------------------------- | ----------- |
| `get_agent_speeds`              | Returns a list of agent speeds                                                                                        | List[float] |
| `get_agent_states`              | Returns a list of agent states, with each index corresponding to the state of that agent at the end of the simulation | List[int]   |
| `get_agent_earliest_departures` | Returns a list of agent earliest departures                                                                           | List[int]   |
| `get_agent_latest_arrivals`     | Returns a list of agent latest arrivals                                                                               | List[int]   |
| `get_agent_arrival_times`       | Returns a list of agent latest arrival times <br> NOTE: Only valid if state == TrainState.DONE                        | List[int]   |
| `get_agent_current_delays`      | Returns a list of current agent delays at the end of the simulation                                                   | List[int]   |
| `get_agent_shortest_paths`      | Returns a list of lengths of shortest paths for each agent                                                            | List[int]   |
