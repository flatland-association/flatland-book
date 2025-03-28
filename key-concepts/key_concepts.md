Key Concepts
============
To help you get a high-level understanding of how the Flatland works, on this page, you learn about the key concepts and general architecture.

We use the terms from [arc42](https://docs.arc42.org/section-7/) for the different views.

[//]: # (icon-park icons from  &#40;https://icones.js.org/collection/icon-park&#41;)

Context View
------------

Notation: [Mermaid Architecture Diagram](https://mermaid.js.org/syntax/architecture.html)

```mermaid
architecture-beta
group flatland(ip:railway)[Flatland]
group ai(ip:brain)[Algorithmic Research]
group ui(ip:data-user)[User Interaction]

service algorithmicResearcher(ip:user)[Algorithmic Researcher] in ai
service evaluator(ip:checklist)[Evaluator] in flatland
service runner(ip:refresh-one)[Runner] in flatland

service railEnv(ip:train)[RailEnv] in flatland
service scenarios(ip:database-config)[Scenarios] in flatland
service policy(ip:six-circular-connection)[AI or OR Agent] in ai
service interactiveAI(ip:map-two)[InteractiveAI] in ui
service operator(ip:user)[Operator] in ui

algorithmicResearcher:B -- T:runner
algorithmicResearcher:B -- T:evaluator
runner:R -- L:railEnv
runner:L -- R:evaluator
scenarios:T -- B:runner
railEnv:T -- B:policy
railEnv:R -- L:interactiveAI
interactiveAI:R -- L:operator
```

High-Level Runtime View
-----------------------



Notation: [Mermaid Sequence Diagram](https://mermaid.js.org/syntax/sequenceDiagram.html)

```mermaid
sequenceDiagram
    participant Runner
    participant Scenarios
    participant Evaluator
    participant RailEnv
    actor Algorithmic Researcher
    participant AI or OR Agent
    participant InteractiveAI
    actor Operator

    box Flatland
        participant Runner
        participant Evaluator
        participant RailEnv
        participant Scenarios
    end

    box Algorithmic Research
        participant Algorithmic Researcher
        participant AI or OR Agent
    end

    box User Interaction
        participant InteractiveAI
        participant Operator
    end

    Algorithmic Researcher -) Runner: scenario
    Runner ->> Scenarios: scenario ID
    Scenarios -->> Runner: scenario
    loop scenario
        Runner ->> AI or OR Agent: observations
        AI or OR Agent -->> Runner: actions
        Runner ->> RailEnv: actions
        RailEnv -->> Runner: observations, rewards, info
        Runner -) InteractiveAI: events, context
        loop interaction
            Operator -) InteractiveAI: requests
            InteractiveAI -) Operator: information, action options
        end
    end

    Runner ->> Evaluator: trajectory
    Evaluator -) Algorithmic Researcher: scenario evaluation
```

Building Block View
-------------------

Notation: [Mermaid Class Diagram](https://mermaid.js.org/syntax/classDiagram.html)

```mermaid
classDiagram
    direction BT
    namespace core {
        class Policy {
            act
        }
        class Environment {
            step
            reset
        }

        class ObservationBuilder
        class PredictionBuilder
        class TransitionMap
        class GridTransitionMap
    }
    namespace callbacks {
        class FlatlandCallbacks {
            on_episode_step
        }
    }
    namespace  core_grid {
        class Transitions
        class Grid4Transitions
        class RailEnvTransitions
    }
    namespace  core_graph {
        class GridTransitionMap
    }
    namespace env_generation {
        class env_generator {
            generate
        }
    }
    namespace envs {
        class RailEnv {
            step
            reset
        }

        class RailGenerator {
            generate
        }
        class RailGeneratorProduct
        class LineGenerator {
            generate
        }
        class Line
        class TimetableGenerator {
            generate
        }
        class Timetable
        class EnvAgent
        class TreeObsForRailEnv
    }

    namespace evaluators {
        class TrajectoryEvaluator

        class FlatlandRemoteClient
        class FlatlandRemoteEvaluationService
    }

    namespace integrations {
        class FlatlandInteractiveAI
    }

    namespace ml {
        class PettingzooFlatland
        class RayMultiAgentWrapper
    }

    namespace trajectories {
        class Trajectory {
            create_from_policy$
        }
    }

    namespace flatland-deadlock-avoidance-heuristic {
        class DeadLockAvoidancePolicy
    }

    namespace pettingzoo {
        class PettingZooParallelEnv["pettingzoo.ParallelEnv"]
    }

    namespace rllib {
        class RllibMultiAgentEnv["ray.rllib.MultiAgentEnv"]
    }
    namespace gymnasium {
        class gymEnv["gymnasium.Env"] {
        }
    }
    RailEnv --|> Environment
    FlatlandInteractiveAI --|> FlatlandCallbacks
    DeadLockAvoidancePolicy --|> Policy
    Grid4Transitions --|> Transitions
    RailEnvTransitions --|> Grid4Transitions
    GridTransitionMap --> TransitionMap
    PettingzooFlatland --|> PettingZooParallelEnv
    RayMultiAgentWrapper --|> RllibMultiAgentEnv
    RllibMultiAgentEnv --|> gymEnv
    PettingZooParallelEnv --|> gymEnv
    TreeObsForRailEnv --|> ObservationBuilder
    RailEnv --> "*" EnvAgent
    RailEnv --> "1" GridTransitionMap
    RailEnv --> "1" RailGenerator
    RailEnv --> "1" LineGenerator
    RailEnv --> "1" TimetableGenerator
    RailEnv --> "1" ObservationBuilder
    PettingZooParallelEnv --> "1" RailEnv
    RayMultiAgentWrapper --> "1" RailEnv
    TransitionMap --> "*" Transitions
    TreeObsForRailEnv --> "1" PredictionBuilder
```

Runtime View RailEnv Step
-------------------------

Notation: [Mermaid Sequence Diagram](https://mermaid.js.org/syntax/sequenceDiagram.html)

```mermaid
flowchart TD
    subgraph rail_env.step
        direction TB
        start(("&nbsp;")) --> pre_step_loop
        subgraph pre_step_loop_ [pre step loop]
            pre_step_loop{Agent loop:<br/> more agents?} -->|yes| preprocess_action
            preprocess_action --> motionCheck.addAgent
            motionCheck.addAgent --> pre_step_loop
        end
        pre_step_loop -->|no| find_conflicts
        find_conflicts --> step_loop
        subgraph step_loop_ [step loop]
            step_loop{Agent loop:<br/> more agents?} -->|yes| check_motion
            check_motion --> state_machen.step
            state_machen.step --> step_loop
        end
        step_loop -->|no| end_of_episode_update
        end_of_episode_update --> record_steps
        record_steps --> get_observations
        get_observations --> get_info_dict
        get_info_dict -->|observations,rewards,infos| end_((("&nbsp;")))
    end
    subgraph legend
        Environment(Environment)
        MotionCheck(MotionCheck)
        RailEnvAgent(RailEnvAgent)
        ObservationBuilder(ObservationBuilder)
    end
    style MotionCheck fill: #ffe, stroke: #333, stroke-width: 1px, color: black
    style find_conflicts fill: #ffe, stroke: #333, stroke-width: 1px, color: black
    style check_motion fill: #ffe, stroke: #333, stroke-width: 1px, color: black
    style RailEnvAgent fill: #fcc, stroke: #333, stroke-width: 1px, color: black
    style state_machen.step fill: #fcc, stroke: #000, stroke-width: 1px, color: black
    style ObservationBuilder fill: #90ee90, stroke: #000, stroke-width: 1px, color: black
    style get_observations fill: #90ee90, stroke: #000, stroke-width: 1px, color: black
    rail_env.step ~~~ legend
```

Runtime View Env Reset
----------------------

Notation: [Mermaid Sequence Diagram](https://mermaid.js.org/syntax/sequenceDiagram.html)

```mermaid
flowchart TD
    subgraph rail_env.reset
        start(("&nbsp;")) -->|data_dir| regenerate_rail{regenerate rail?}
        regenerate_rail -->|no| regenerate_line{regenerate line?}
        regenerate_rail -->|yes| generate_rail
        regenerate_line -->|yes| generate_line
        regenerate_line -->|no| reset_agents
        generate_rail --> generate_line
        generate_line --> generate_timetable
        generate_timetable --> reset_agents
        reset_agents -->|observations,infos| end_((("&nbsp;")))
    end

```