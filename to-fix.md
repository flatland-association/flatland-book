# **environment/level_generation.md > available rail generators**

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

![rail_from_manual_specifications](../assets/images/fixed_rail.png)