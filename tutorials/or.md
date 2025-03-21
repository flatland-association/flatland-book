Operations Research
====================

Optimal solutions to the The Vehicle Re-scheduling Problem in flatland env can be obtained by formulating and solving optimization problems. Iterative/Closed
form solutions for VRSP have been heavily explored in Operations Research.

Although such methods produce optimal and efficient schedules time to find these solutions generally scale nonlinearly with size of env and the number of agents
which motivates us look into rl for faster solutions.

Baselines:

* 🧲 [shortest path deadlock avoidance](https://github.com/flatland-association/flatland-baselines/tree/main/flatland_baselines/deadlock_avoidance_heuristic).
  👏Thanks to [aiAdrian](https://github.com/aiAdrian/flatland-benchmarks-f3-starterkit/tree/DeadLockAvoidancePolicy) for contributing!