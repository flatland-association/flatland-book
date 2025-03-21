Stochasticity
=====================

Malfunctions are implemented to simulate delays by stopping agents at random times for random durations. Trains that malfunction can’t move for a random, but
known, number of steps. They of course block the trains following them 😬.
Malfunctions

Stochastic events are common in railway networks. The initial plan often needs to be rescheduled during operations as minor events such as delayed departure
from train stations, various malfunctions on trains or infrastructure, or even problematic weather lead to delayed trains.

Malfunctions are implemented using a [Poisson process](https://en.wikipedia.org/wiki/Poisson_point_process) to simulate delays by stopping agents at random
times for random durations. Train that malfunction can't move for a random, but known, number of steps. They of course block the trains following them 😬

The parameters necessary for the stochastic events are provided as a `NamedTuple` called `MalfunctionParameters`:

```python
stochastic_data = MalfunctionParameters(
    malfunction_rate=1 / 10000,  # Rate of malfunction occurence
    min_duration=15,  # Minimal duration of malfunction
    max_duration=50  # Max duration of malfunction
)
```

The parameters are as follows:

- `malfunction_rate` is the mean rate of the poisson process in number of environment steps.
- `min_duration` and `max_duration` set the range of malfunction durations. They are sampled uniformly.

You can then introduce stochasticity in an environment by using the `malfunction_generator` parameter of the `RailEnv` constructor:

```python
RailEnv(
    ...
malfunction_generator = ParamMalfunctionGen(stochastic_data),
...
)
```

In your controller, you can then check whether an agent is malfunctioning:

```python
obs, rew, done, info = env.step(actions)
...
action_dict = dict()
for a in range(env.get_num_agents()):
    if info['malfunction'][a] > 0:
# agent is malfunctioning and can't move!
# info['malfunction'][a] contains the number of steps this agent will still be blocked
```

You will quickly realize that this will lead to unforeseen difficulties which means that your controller needs to observe the environment at all times to be
able to react to the stochastic events!

<!-- [Check out the starter kit](https://gitlab.aicrowd.com/flatland/neurips2020-flatland-starter-kit/blob/master/reinforcement_learning/multi_agent_training.py#L55) for a complete example of how to train a model using malfunctions. -->