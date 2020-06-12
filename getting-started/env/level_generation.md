Level Generation
================

Flatland provides multiple ways to create random environments. The most important one is the [`sparse_rail_generator`](https://gitlab.aicrowd.com/flatland/flatland/blob/master/flatland/envs/rail_generators.py#L563), which generates realistic-looking railway networks.

Sparse rail generator
---------------------

The idea behind the sparse rail generator is to mimic classic railway structures where dense nodes (cities) are sparsely connected to each other and where you have to manage traffic flow between the nodes efficiently.
The cities in this level generator are much simplified in comparison to real city networks but they mimic parts of the problems faced in daily operations of any railway company.

![sparse rail](../../assets/images/sparse_railway.png)

There are a number of parameters you can tune to build your own map and test different complexity levels of the levels.

```{note}
Some combinations of parameters do not go well together and will lead to infeasible level generation.
In the worst case, the level generator will issue a warning when it cannot build the environment according to the parameters provided.
```

To build an environment, instantiate a `RailEnv` as follow:

```python
rail_generator=sparse_rail_generator(
    max_num_cities: int = 5,
    grid_mode: bool = False,
    max_rails_between_cities: int = 4,
    max_rails_in_city: int = 4, 
    seed=0
)

env = RailEnv(
    width=50, height=50,
    rail_generator=rail_generator,
    schedule_generator=sparse_schedule_generator(),
    number_of_agents=10
)

env.reset()
```

You can see that you now need both a `rail_generator` and a `schedule_generator` to generate a level. These need to work nicely together. The `rail_generator` will generate the railway infrastructure and provide hints to the `schedule_generator` about where to place agents. The `schedule_generator` will then generate a schedule by placing agents at different train stations and providing them with individual targets.

You can tune the following parameters in the `sparse_rail_generator`:

- `max_num_cities`: Maximum number of cities to build. The generator tries to achieve this numbers given all the other parameters. Cities are the only nodes that can host start and end points for agent tasks (train stations). 

- `grid_mode`: How to distribute the cities in the path, either equally in a grid or randomly.

- `max_rails_between_cities`: Maximum number of rails connecting cities. This is only the number of connection points at city border. The number of tracks drawn in-between cities can still vary.

- `max_rails_in_city`: Maximum number of parallel tracks inside the city. This represents the number of tracks in the train stations.

- `seed`: The random seed used to initialize the random generator. Can be used to generate reproducible networks.

Manually specified railway
--------------------------

It is possible to manually design railway networks using [`rail_from_manual_specifications_generator`](https://gitlab.aicrowd.com/flatland/flatland/blob/master/flatland/envs/rail_generators.py#L182).

It accepts a list of lists whose each element is a 2-tuple, whose entries represent the `cell_type` (see `core.transitions.RailEnvTransitions`) and the desired clockwise rotation of the cell contents (0, 90, 180 or 270 degrees):

```python
specs = [[(0, 0), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0)],
         [(0, 0), (0, 0), (0, 0), (0, 0), (7, 0), (0, 0)],
         [(7, 270), (1, 90), (1, 90), (1, 90), (2, 90), (7, 90)],
         [(0, 0), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0)]]

env = RailEnv(width=6, height=4,
              rail_generator=rail_from_manual_specifications_generator(specs),
              number_of_agents=1
env.reset()
```

![rail_from_manual_specifications](../../assets/images/fixed_rail.png)

Other rail generators
---------------------

```{note}
Only the `sparse_rail_generator` will be used for evaluations in the context of the [NeurIPS 2020 challenge](https://www.aicrowd.com/challenges/neurips-2020-flatland-challenge/).
```

Other rail generators are available and can be used for example if you want more diversity in your training set:

- [`complex_rail_generator`](https://gitlab.aicrowd.com/flatland/flatland/blob/master/flatland/envs/rail_generators.py#L42)
- [`random_rail_generator`](https://gitlab.aicrowd.com/flatland/flatland/blob/master/flatland/envs/rail_generators.py#L282)