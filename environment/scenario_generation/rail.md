Rail Generator
================


## Available Rail Generators

Flatland provides the [`sparse_rail_generator`](https://github.com/flatland-association/flatland-rl/blob/main/flatland/envs/rail_generators.py#L563), which generates realistic-looking railway networks.

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
    max_num_cities=2,
    grid_mode=False,
    max_rails_between_cities=2,
    max_rail_pairs_in_city=2, 
    seed=0
)

env = RailEnv(
    width=30, height=30,
    rail_generator=rail_generator,
    line_generator=sparse_line_generator(),
    number_of_agents=10
)

env.reset()
```

You can see that you now need both a `rail_generator` and a `line_generator` to generate a level. These need to work nicely together. The `rail_generator` will generate the railway infrastructure and provide hints to the `line_generator` about where to place agents. The `line_generator` will then generate a Line by placing agents at different train stations and providing them with individual targets.

You can tune the following parameters in the `sparse_rail_generator`:

- `max_num_cities`: Maximum number of cities to build. The generator tries to achieve this numbers given all the other parameters. Cities are the only nodes that can host start and end points for agent tasks (train stations). 

- `grid_mode`: How to distribute the cities in the path, either equally in a grid or randomly.

- `max_rails_between_cities`: Maximum number of rails connecting cities. This is only the number of connection points at city border. The number of tracks drawn in-between cities can still vary.

- `max_rails_in_city`: Maximum number of parallel tracks inside the city. This represents the number of tracks in the train stations.

- `seed`: The random seed used to initialize the random generator. Can be used to generate reproducible networks.


