Key Concepts
============
To help you get a high-level understanding of how the Flatland works, on this page, you learn about the key concepts and general architecture.

We use the terms from [arc42](https://docs.arc42.org/section-7/) for the different views.

[//]: # (icon-park icons from  &#40;https://icones.js.org/collection/icon-park&#41;)

Flatland Code Repositories
--------------------------

* [**flatland-rl**](https://github.com/flatland-association/flatland-rl) contains the environment and evaluation code
* [**flatland-baselines**](https://github.com/flatland-association/flatland-baselines) contains baseline controllers/agents
* [**flatland-scenarios**](https://github.com/flatland-association/flatland-scenarios) contains scenarios for illustration, regression testing and benchmarking
* [**flatland-book**](https://github.com/flatland-association/flatland-book) contains the source code for this documentation

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
        class GraphTransitionMap
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
        start(("&nbsp;")) --> effects_generator.on_episode_step_start[effects_generator<br/>.on_episode_step_start]
        effects_generator.on_episode_step_start --> pre_step_loop
        subgraph pre_step_loop_ [pre step loop]
            pre_step_loop{Agent loop:<br/> more agents?} -->|yes| generate_malfunction[malfunction_handler<br/>.generate_malfunction]
            generate_malfunction --> preprocess_action
            preprocess_action --> compute_position_direction_speed_update[compute_<br/>position_direction_speed_<br/>update]
            compute_position_direction_speed_update --> motion_check.addAgent
            motion_check.addAgent --> pre_step_loop
        end
        pre_step_loop -->|no| motion_check.find_conflicts[motion_check<br/>.find_conflicts]
        motion_check.find_conflicts --> step_loop
        subgraph step_loop_ [step loop]
            step_loop{Agent loop:<br/> more agents?} -->|yes| motion_check.check_motion[motion_check<br/>.check_motion]
            motion_check.check_motion --> state_machine.step
            state_machine.step --> update_position_direction_speed[update_<br/>position_direction_speed]
            update_position_direction_speed --> handle_done_state
            handle_done_state --> step_reward
            step_reward --> malfunction_handler.update_counter[malfunction_handler<br/>.update_counter]
            malfunction_handler.update_counter --> agent_step_validate_invariants[agent_step_<br/>validate_invariants]
            agent_step_validate_invariants --> step_loop
        end
        step_loop -->|no| end_of_episode_update
        end_of_episode_update --> step_validate_invariants[step_<br/>validate_invariants]
        step_validate_invariants --> record_steps
        record_steps --> effects_generator.on_episode_step_end[effects_generator<br/>.on_episode_step_end]
        effects_generator.on_episode_step_end --> get_observations
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
    style motion_check.check_motion fill: #ffe, stroke: #333, stroke-width: 1px, color: black
    style motion_check.find_conflicts fill: #ffe, stroke: #333, stroke-width: 1px, color: black
    style motion_check.addAgent fill: #ffe, stroke: #333, stroke-width: 1px, color: black
    style RailEnvAgent fill: #fcc, stroke: #333, stroke-width: 1px, color: black
    style state_machine.step fill: #fcc, stroke: #000, stroke-width: 1px, color: black
    style ObservationBuilder fill: #90ee90, stroke: #000, stroke-width: 1px, color: black
    style get_observations fill: #90ee90, stroke: #000, stroke-width: 1px, color: black
    rail_env.step ~~~ legend
```

| step                                     | description                                                                                                                                                                                                                                                                                                                                             |
|------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| effects_generator.on_episode_step_start  | Hook for external events modifying the env (state) before observations and rewards are computed.                                                                                                                                                                                                                                                        |
| malfunction_handler.generate_malfunction | Draw malfunctions                                                                                                                                                                                                                                                                                                                                       |
| preprocess_action                        | 1. Change to DO_NOTHING if illegal action (not one of the defined action); <br/> 2. Check MOVE_LEFT/MOVE_RIGHT actions on current position else try MOVE_FORWARD; <br/>  3. Change to STOP_MOVING if the movement is not possible in the grid (e.g. if MOVE_FORWARD in a symmetric switch or MOVE_LEFT in straight element or leads outside of bounds). |
| compute_position_direction_speed_update  | Based on preprocessed action and current state, compute next position/direction/speed unilaterally.                                                                                                                                                                                                                                                     |
| motion_check.addAgent                    | Register the new position/direction with the MotionCheck conflict resolution.                                                                                                                                                                                                                                                                           |
| motion_check.find_conflicts              | Find and resolve conflicts.                                                                                                                                                                                                                                                                                                                             |
| motion_check.check_motion                | Check whether the next position/direction is possible given the other agents' desired updates.                                                                                                                                                                                                                                                          |
| state_machine.step                        | With MotionCheck's decision for this agent, do agent state machine transition.                                                                                                                                                                                                                                                                          |
| update_position_direction_speed          | Based on the new state, update position/direction/speed.                                                                                                                                                                                                                                                                                                |
| handle_done_state                        | Based on the new position, check whether target is reached and remove agent if `remove_agents_at_target` is set in the env.                                                                                                                                                                                                                             |
| step_reward                              | Compute step rewards.                                                                                                                                                                                                                                                                                                                                   |
| malfunction_handler.update_counter       | Update current malfunctions.                                                                                                                                                                                                                                                                                                                            |
| agent_step_validate_invariants           | Validate invariants at agent level, in particular check for whether on map and off map states are matching with position being None                                                                                                                                                                                                                     |
| end_of_episode_update                    | Have all agents terminated?                                                                                                                                                                                                                                                                                                                             |
| step_validate_invariants                 | Validate overall  invariants, in particular verify that no two agents occupy the same cell (apart from level-free diamond crossings).                                                                                                                                                                                                                   |
| record_steps                             | Records steps.                                                                                                                                                                                                                                                                                                                                          |
| effects_generator.on_episode_step_end    | Hook for external events modifying the env (state) before observations and rewards are computed.                                                                                                                                                                                                                                                        |
| get_observations                         | Call observation builder for all agents.                                                                                                                                                                                                                                                                                                                |
| get_info_dict                            | Prepare infos for all agents.                                                                                                                                                                                                                                                                                                                           |

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
        reset_agents --> effects_generator.on_episode_start
        effects_generator.on_episode_start --> get_info_dict
        get_info_dict --> get_observations
        get_observations -->|observations,infos| end_((("&nbsp;")))
    end

```