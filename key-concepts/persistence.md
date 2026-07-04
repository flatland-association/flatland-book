# Flatland Persistence

Conceptual preparation for https://github.com/flatland-association/flatland-rl/issues/129

### Environment State

Defines the state deterministically, including random state, so setting the state and stepping gives commutatively the same state.
(Obviously, this definition is only necessary, but not sufficient - single `None` state would satisfy this definition.)

```python
from abc import abstractmethod, ABCMeta
from typing import TypeVar, Generic

T = TypeVar('T')


class Persistable(Generic[T]):
    def save(self, path):
        ...

    @staticmethod
    def load(self, path) -> T:
        ...


State = TypeVar('State', covariant=True)


class Environment(Persistable[State], metaclass=ABCMeta):
    @abstractmethod
    def __getstate__(self) -> State:
        ...

    def __setstate__(self, state: State):
        ...


class EnvState(Persistable["EnvState"]):

    @property
    def get_configuration(self) -> "EnvConfiguration":
        ...


if __name__ == '__main__':
    some_env = ...
    some_seed = ...
    any_other_env = ...
    some_actions = ...
    some_env.reset(some_seed)

    any_other_env.__setstate__(some_env.__getstate__())
    assert any_other_env.__getstate__() == some_env.__getstate__()

    some_env.step(some_actions)
    any_other_env.step(some_actions)

    assert any_other_env.__getstate__() == some_env.__getstate__()

    some_env.reset(some_seed)
    any_other_env.reset(some_seed)

    assert any_other_env.__getstate__() == some_env.__getstate__()
```

```json
{
  "meta": {
    "version": 0.1,
    "type": "Flatland Digital Environment State"
  },
  "random_state": {},
  "rail": {},
  "stations": {},
  "lines": {},
  "timetable": {},
  "agents": {}
}
```

### Environment Configuration

Defines the environment, so if we control the seed, exactly the same env with same state comes out:

```python
from ... import Persistable


class EnvConfiguration(Persistable["EnvConfiguration"]):
    pass


class Environment:

    def configuration(self) -> "EnvConfiguration":
        ...

    @staticmethod
    def from_configuration(pathOrConfiguration) -> "Environment":
        ...


if __name__ == '__main__':
    some_env = ...
    some_seed = ...
    configuration = some_env.get_configuration()
    env = Environment.from_configuration(configuration)

    assert env.from_configuration(configuration).reset(some_seed).__getstate__() == some_env.reset(some_seed).__getstate__()
```

```json
{
  "meta": {
    "version": 0.1,
    "type": "Flatland Digitial Environment Configuration"
  },
  "cls": "flatland.envs.rail_env.RailEnv",
  "kwargs": {
    "acceleration_delta": 1.0,
    "braking_delta": -1.0,
    "observation_builder": {
      "cls": "...",
      "kwargs": {}
    }
  },
  "reset_generators": {
    "rail": {
      "cls": "...",
      "kwargs": {}
    },
    "line": {
      "cls": "...",
      "kwargs": {}
    },
    "timetable": {
      "cls": "...",
      "kwargs": {}
    }
  },
  "effects_generators": [
    {
      "cls": "...",
      "kwargs": {}
    }
  ],
  "rewards": {
    "cls": "...",
    "kwargs": {}
  }
}
```
