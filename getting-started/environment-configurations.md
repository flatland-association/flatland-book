Environment Configurations
==========================

In Round 1, the configuration of all of the evaluation environments is disclosed! The only parameter kept secret is the seed to ensure that the submissions solve the problems in a generalisable way. 

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