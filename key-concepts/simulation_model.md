# Flatland Data and Simulation Model

## Overview

The following digram shows the RL control loop,

```python
obs, rewards, dones, info = env.step(action_dict)
```

showing the flow of inputs and outputs of `step`:

```mermaid
flowchart LR
    subgraph PolicyRunner
    end
    subgraph RailEnv
        agent((agent))
        Rewards
        ObservationBuilder
        EffectsGenerator
        TransitionMap
        ResourceMap
    end
    subgraph Policy
        agent_policy((agent))

    end
    RailEnv -->|observations| Policy
    Policy -->|actions| RailEnv
    agent o--o agent_policy
    RailEnv -->|info| PolicyRunner
    RailEnv -->|rewards| PolicyRunner

```

Adapted from [RLlib](https://docs.ray.io/en/latest/rllib/rllib-env.html#rllib-environments-doc).

## Glossary

### Flatland Environment

| Concept             | Description                                                                                                                                                                                                                                                                |
|---------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Agent               | Each train is a single agent in Flatland.                                                                                                                                                                                                                                  |
| (MA)RL Loop         | (Multi-Agent) Reinforcement Learning Loop is a control loop: a policy receives observations from the env and outputs actions. See above.                                                                                                                                   |
| Policy              | Recevies an observation for each agent and outputs an action for each agent. The policy may consist of a single sub-policy applied to each agent unilaterally or it may have different sub-policies for each agent individually or even consider all observations jointly. |
| Policy Runner       | Takes an env and a policy and runs the MARL loop for evaluation by calling `obs, rewards, dones, info = env.step(action_dict)` iteratively until done.                                                                                                                     |
| Callbacks           | Callbacks at the start and end of an episode (`on_episode_start`, `on_episode_end`) and after each env step (`on_episode_step`), called by the policy runner.                                                                                                              |
| Trajectory          | The output of a policy run: actions, positions, rewards.                                                                                                                                                                                                                   |
| Actions             | An action for each agent.                                                                                                                                                                                                                                                  |
| Rewards             | A reward (number or dict) for each agent. Also used for the component building the rewards during `step`.                                                                                                                                                                  |
| Effects Generator   | Called by the env at the start of an episode (`on_episode_start`, in `reset`) and at the start and end of each `step` (`on_episode_step_start`, `on_episode_step_end`) to modify the env's state, e.g. injecting disruptions.                                              |
| Observation Builder | Called by env to build the observation from the env's state.                                                                                                                                                                                                               |
| Entry Point         | Each agent is at an entry point, i.e. a cell and the direction in which it entered it in the grid or a node in the graph, and has already chosen its next entry point. Updated by env during a `step`.                                                                     |
| Transition Map      | Defines the topology the agents live in, i.e. the entry points and transitions between them as well as actions required for the transition.                                                                                                                                |
| Resource Map        | Defines which resources are used by the topology elements, e.g. rails can be allocated only mutually exclusively. Currently, each topology element requires exactly one resource.                                                                                          |

```mermaid
classDiagram
    namespace Core {
        class Environment {
            <<interface>>
        }
        class TransitionMap {
            <<interface>>
        }

        class ResourceMap {
            <<interface>>
        }
        class GridTransitionMap {
        }
    }
    namespace Rail {
        class AbstractRailEnv {
        }
        class RailEnv {
        }
        class GraphTransitionMap {
        }
    }

    AbstractRailEnv --|> Environment
    RailEnv --|> AbstractRailEnv
    GridTransitionMap --|> TransitionMap
    GraphTransitionMap --|> TransitionMap
    AbstractRailEnv --> TransitionMap
    AbstractRailEnv --> ResourceMap
```

### Flatland Transition Maps

| Concept        | Grid                                                                                                                                                                                                                                                | Graph                                                                                                                                                      |
|----------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Coordinate     | Row, column, direction how cells can be entered: `((r,c),d)`.                                                                                                                                                                                       | A **node** (`str`), i.e. a cell entry pin.                                                                                                                 |
| Transition Map | For each coordinate, which are possible successor coordinates.                                                                                                                                                                                      | A pair of **node**s defines a directed **edge**.                                                                                                           |
| Entry Point    | Row, column and the direction in which the cell was entered: `((r,c),d)`. The agent is on its way from its current to its next entry point, `speed_counter.distance` is the offset; speed and malfunction counter are kept separately in the agent. | A node.                                                                                                                                                    |
| Resource Map   | Each `row,col=cell` is a mutually exclusively allocatable resource.                                                                                                                                                                                 | Each node is mapped to a mutually exclusively allocatable resource (`GraphResourceMap`); nodes reflecting common physical infrastructure share a resource. |

Up to `flatland 4.3.0`, entry points were called configurations (`initial_configuration`, `current_configuration`, `target_configuration`, `ConfigurationDistanceMap`).
Since `flatland 5.0.0`, they are entry points (`initial_entry_point`, `current_entry_point`, `target_entry_point`, `EntryPointDistanceMap`), and the agent
additionally holds its `next_entry_point`.

### Flatland Rail

| Concept               | Description                                                                                                                                                                                                                                                                |
| --------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Malfunction Generator | An instance of effects generator, changing agent's state.                                                                                                                                                                                                                  |
| Rail (Generator)      | Outputs a transition map and stopping points, and, optionally, stations and links.                                                                                                                                                                                         |
| Line (Generator)      | Outputs a sequence of stops, which are sets of entry points. The first is a singleton called initial entry point; the last is called target; the others are called intermediate stops.                                                                                     |
| Timetable (Generator) | Adds a time window (earliest, latest) for each stop. Earliest of the initial entry point is enforced by the simulation (putting the agent's state to ready to depart in the env); the remaining are used in the rewards for penalizing late arrival or early departure.   |
| Station               | Collection of stopping points and gates.                                                                                                                                                                                                                                   |
| City                  | In sparse rail generator, internally used alias for station.                                                                                                                                                                                                               |
| Stopping Point        | "Bahnhofsmitte" entry points where agents can stop.                                                                                                                                                                                                                        |
| Gate                  | A collection of pins.                                                                                                                                                                                                                                                      |
| Link                  | Connects two gates. Has fibres. Not all pairs of pins in the gate need be connected.                                                                                                                                                                                       |
| Fibre                 | A sequence of transitions linking two pins of a link.                                                                                                                                                                                                                      |
| Pin                   | A single entry point attached to a gate.                                                                                                                                                                                                                                   |
| Chain                 | A sequence of links terminating/starting at the same station at different reachable gates.                                                                                                                                                                                 |
