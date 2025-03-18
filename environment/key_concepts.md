Key Concepts
============
To help you get a high-level understanding of how the Flatland works, on this page, you learn about the key concepts and general architecture.

```mermaid
sequenceDiagram
    actor Algorithmic Researcher
    box Flatland
        participant Runner
        participant Evaluator
        participant RailEnv

    end

    Algorithmic Researcher -) Runner: scenario
    loop scenario
        Runner ->> Policy: observations
        Policy -->> Runner: actions
        Runner ->> RailEnv: actions
        RailEnv -->> Runner: observations, rewards, info
        Runner -) InteractiveAI: events, context
        loop interaction
            Operator -) InteractiveAI: requests
            InteractiveAI -) Operator: information, action options
        end
    end
    actor Operator
    Runner ->> Evaluator: trajectory
    Evaluator -) Algorithmic Researcher: scenario evaluation
```

Building Block View
-------------------

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
    RailEnv --> "1" Line
    RailEnv --> "1" Timetable
    RailEnv --> "1" ObservationBuilder
    PettingZooParallelEnv --> "1" RailEnv
    RayMultiAgentWrapper --> "1" RailEnv
    TransitionMap --> "*" Transitions
    TreeObsForRailEnv --> "1" PredictionBuilder
```

Data Model
----------

```mermaid
classDiagram
    class Trajectory
    Trajectory: +Path data_dir
    Trajectory: +UUID ep_id
    Trajectory: +run(int from_step, int to_step=-1)
    Trajectory: +verify()
    Trajectory: +from_submission(Policy policy, ObservationBuilder obs_builder, int snapshot_interval)$ Trajectory

    class EnvSnapshot
    EnvSnapshot: +Path data_dir
    Trajectory: +UUID ep_id

    class EnvConfiguration
    EnvConfiguration: +int max_episode_steps
    EnvConfiguration: +int height
    EnvConfiguration: +int width
    EnvConfiguration: +Rewards reward_function
    EnvConfiguration: +MalGen
    EnvConfiguration: +RailGen etc. reset

    class EnvState
    EnvState: +Grid rail

    namespace RailEnv {
        class EnvConfiguration

        class EnvState
    }

    class EnvActions

    class EnvRewards

    EnvSnapshot --> "1" EnvConfiguration
    EnvSnapshot --> "1" EnvState
    Trajectory --> "1" EnvConfiguration
    Trajectory --> "1..*" EnvState
    Trajectory --> "1..*" EnvActions
    Trajectory --> "1..*" EnvRewards

    class Policy
    Policy: act(int handle, Observation observation)

    class ObservationBuilder
    ObservationBuilder: get()
    ObservationBuilder: get_many()

    class Submission
    Submission --> "1" Policy
    Submission --> ObservationBuilder
```

Remarks:

* Trajectory needs not start at step 0
* Trajectory needs not contain state for every step - however, when starting the trajectory from an intermediate step, the snapshot must exist.

Flow Runner
-----------

```mermaid
flowchart TD
    subgraph Trajectory.create_from_policy
        start(("&nbsp;")) -->|data_dir| D0
        D0(RailEnvPersister.load_new) -->|env| E{env done?}
        E -->|no:<br/>observations| G{Agent loop:<br/> more agents?}
        G --->|observation| G1(policy.act)
        G1 -->|action| G
        G -->|no:<br/> actions| F3(env.step)
        F3 -->|observations,rewards,info| E
        E -->|yes:<br/> rewards| H((("&nbsp;")))
    end

    style Policy fill: #ffe, stroke: #333, stroke-width: 1px, color: black
    style G1 fill: #ffe, stroke: #333, stroke-width: 1px, color: black
    style Env fill: #fcc, stroke: #333, stroke-width: 1px, color: black
    style F3 fill: #fcc, stroke: #333, stroke-width: 1px, color: black
    subgraph legend
        Env(Environment)
        Policy(Policy)
        Trajectory(Trajectory)
    end

    Trajectory.create_from_policy~~~legend

```

Flow RailEnv Step
-----------------

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
    rail_env.step~~~legend
```

Flow Env Reset
--------------

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