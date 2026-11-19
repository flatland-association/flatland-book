Environment Configurations
===

In this challenge, the configuration of all of the evaluation environments is disclosed! The only parameter kept secret is the seed to ensure that the submissions solve the problems in a generale way. 

## NeurIPS 2020

### Round 2

**In Round 2, your submission has to solve as many environments as possible in 8 hours.** The number of environments is such that it is not possible to solve them all in 8 hours (if anyone manages to reach the end, we'll just generate more 😉).

The environments start very small and have increasingly larger sizes. The evaluation stops when less than 25% of the agents reach their target (averaged over each test of 10 episodes), or after 8h, whichever comes first. Each solved environment awards you points, and the goal is to get as many points as possible.

**This means that the challenge is not only to find the best solutions possible, but also to find solutions quickly!** This is consistent with the business requirements of railway companies: it’s very important for them to be able to re-route trains as fast as possible when a malfunction occurs.

Each test consists of 10 environments. Each environment in a test has a different malfunction interval (the malfunction interval is the inverse of the malfunction rate):

- **Level_0:** no malfunction at all
- **Level_1:** `malfunction_interval = min_malfunction_interval = 250`
- **Level_2:** `malfunction_interval = 2*min_malfunction_interval = 500`
- ...
- **Level_9:** `malfunction_interval = 9*min_malfunction_interval = 2250`

For each environment, you get a normalized reward between `0.0` and `1.0` (equal to the normalized reward as defined in Round 1 + 1.0). The final score is the sum of all the normalized rewards. See the [Evaluation Metrics](prize-and-metrics.md) page for more details. 

All the environment use the following parameters in Round 2:
- `n_envs_run = 10`
- `min_malfunction_interval = 250`
- `max_rails_in_city = 4`
- `malfunction_duration = [20,50]`
- `max_rails_between_cities = 2`
- `speed_ratios = {1.0: 1.0}`
- `grid_mode = False`

**Remember that the goal is no longer to solve all the tests - this list is infinite!** The goal is to solve as many as possible, with the best score possible, within the 8h overall time limit.

The environment parameters are calculated as follow:
- $n\_agents_{n+1} = n\_agents_{n}+ceiling(10^{len(n\_agents_{n})}-1)*0.75$
- $n\_cities_{n} = (n\_agents_{n} // 10) + 2$
- $x\_dim_{n} = ceiling(sqrt((2*(ceiling(max\_rails\_in\_city/2) + 3))^2*(1.5*n\_cities_{n})))+7$
- $y\_dim_{n} = x\_dim_{n}$

You can check out [this Google Spreadsheet](https://docs.google.com/spreadsheets/d/1KKftZGLEKo3c2hgNLhGnePFmC3tIqgXLlsSVBJ22s-E/edit) to calculate the parameters for any environments.

| test     | n_agents      | x_dim   | y_dim   | n_cities     |
|----------|---------------|---------|---------|--------------|
| Test_0   |             1 |      25 |      25 |            2 |
| Test_1   |             2 |      25 |      25 |            2 |
| Test_2   |             3 |      25 |      25 |            2 |
| Test_3   |             4 |      25 |      25 |            2 |
| Test_4   |             5 |      25 |      25 |            2 |
| Test_5   |             6 |      25 |      25 |            2 |
| Test_6   |             7 |      25 |      25 |            2 |
| Test_7   |             8 |      25 |      25 |            2 |
| Test_8   |             9 |      25 |      25 |            2 |
| Test_9   |            10 |      29 |      29 |            3 |
| Test_10  |            18 |      29 |      29 |            3 |
| Test_11  |            26 |      32 |      32 |            4 |
| Test_12  |            34 |      35 |      35 |            5 |
| Test_13  |            42 |      37 |      37 |            6 |
| Test_14  |            50 |      40 |      40 |            7 |
| Test_15  |            58 |      40 |      40 |            7 |
| Test_16  |            66 |      42 |      42 |            8 |
| Test_17  |            74 |      44 |      44 |            9 |
| Test_18  |            82 |      46 |      46 |           10 |
| Test_19  |            90 |      48 |      48 |           11 |
| Test_20  |            98 |      48 |      48 |           11 |
| Test_21  |           106 |      50 |      50 |           12 |
| Test_22  |           181 |      62 |      62 |           20 |
| Test_23  |           256 |      71 |      71 |           27 |
| Test_24  |           331 |      80 |      80 |           35 |
| Test_25  |           406 |      87 |      87 |           42 |
| Test_26  |           481 |      94 |      94 |           50 |
| Test_27  |           556 |     100 |     100 |           57 |
| Test_28  |           631 |     106 |     106 |           65 |
| Test_29  |           706 |     111 |     111 |           72 |
| Test_30  |           781 |     117 |     117 |           80 |
| Test_31  |           856 |     122 |     122 |           87 |
| Test_32  |           931 |     127 |     127 |           95 |
| Test_33  |          1006 |     131 |     131 |          102 |
| Test_34  |          1756 |     170 |     170 |          177 |
| Test_35  |          2506 |     202 |     202 |          252 |
| Test_36  |          3256 |     229 |     229 |          327 |
| Test_37  |          4006 |     253 |     253 |          402 |
| Test_38  |          4756 |     275 |     275 |          477 |
| Test_39  |          5506 |     295 |     295 |          552 |
| Test_40  |          6256 |     314 |     314 |          627 |
| ...      |        ...    |    ...  |    ...  |        ...   |


### Round 1

`n_envs_run` indicates the number of environments ran for each test. A mean score is calculated for each of the 14 tests. The final score is the mean of these means.

The malfunction interval differs from environment to environment, but it is never smaller than `min_malfunction_interval`. In each test, some environments have no malfunctions at all.

All the environment use the following parameters in Round 1:
- `malfunction_duration = [20,50]`
- `max_rails_between_cities = 2`
- `speed_ratios = {1.0: 1.0}`
- `grid_mode = False`

| test    | n_agents | x_dim | y_dim | n_cities | max_rails_in_city | min_malfunction_interval | n_envs_run |
|---------|----------|-------|-------|----------|-------------------|----------------------|------------|
| Test_0  |        5 |    25 |    25 |        2 |                 3 |                   50 |         50 |
| Test_1  |       10 |    30 |    30 |        2 |                 3 |                  100 |         50 |
| Test_2  |       20 |    30 |    30 |        3 |                 3 |                  200 |         50 |
| Test_3  |       50 |    20 |    35 |        3 |                 3 |                  500 |         40 |
| Test_4  |       80 |    35 |    20 |        5 |                 3 |                  800 |         30 |
| Test_5  |       80 |    35 |    35 |        5 |                 4 |                  800 |         30 |
| Test_6  |       80 |    40 |    60 |        9 |                 4 |                  800 |         30 |
| Test_7  |       80 |    60 |    40 |       13 |                 4 |                  800 |         30 |
| Test_8  |       80 |    60 |    60 |       17 |                 4 |                  800 |         20 |
| Test_9  |      100 |    80 |   120 |       21 |                 4 |                 1000 |         20 |
| Test_10 |      100 |   100 |    80 |       25 |                 4 |                 1000 |         20 |
| Test_11 |      200 |   100 |   100 |       29 |                 4 |                 2000 |         10 |
| Test_12 |      200 |   150 |   150 |       33 |                 4 |                 2000 |         10 |
| Test_13 |      400 |   150 |   150 |       37 |                 4 |                 4000 |         10 |