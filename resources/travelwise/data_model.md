Travel Wise Data Model
===================

This page gives technical details to the general approach of [Travel Wise](../travelwise).

## Building Blocks

Flatland represents RL view of the world: agent policies act on the env upon receiving a (partial) observation of the env state.
The world is run by a controller loop and the run is collected in a trajectory.

External effects can be modelled by effects generators, modifying the environment state before or after an env step, reflecting e.g.

- random disruptions of trains (due to door not closing, passenger delaying departure etc.)
- availability of infrastructure (e.g. opening a passenger fast-lane at airports)

The railway domain is reflected at the microscopic level:

* infrastructure/topology is defined by the transition map and stations and stops in the map
* services are defined spatially by lines and spatio-temporally by timetables

The Travel Wise extension reflects passenger journeys.

Technically, it is an extension of RailEnv, but also refers to an underlying RailEnv where trains, ships
etc. run.

```mermaid
classDiagram
    direction LR
    note for TravelWiseEnv "Agents reflect passengers and configurations represent passenge locations and policies drive passengers; TODO: what are the actions"
    note for RailEnv "Agents reflect trains/ships/etc. Configurations can be graph nodes or grid cell entry points (r,c,d)."
    note for TransitionMap "Topology"
    note for Line "Services in Space"
    note for Timetable "Services in Space and Time"
    note for EnvAgent "TODO: alternatively, this is the next configuration chosen by the action; configuration,next_configuration is then the edge"
    note for Stop "aka. Haltepunkt"
    Journey --> Itinerary: current
    PassengerLocation "1" --> "0..1" Stop
    RailEnv --> TransitionMap
    AgentTimetable "1" --> "1" Line
    AgentTimetable "1" --> "2..." AgentTimetableItem: timetable
    TravelWiseEnv --|> RailEnv
    TravelWiseEnv --> "passengers use trains, ships etc." RailEnv
    Stop "1.." --> "1" Station
    Stop "0,1" --> "1" Configuration
    Line "1" --> "1.." LineFlexibleStop
    LineFlexibleStop "1.." --> "1.." Stop

    namespace Controller {
        class Trajectory {
            env: RailEnv
            policy: FlatlandPolicy
        }
    }

    namespace Flatland {
        class RailEnv {
            effects_generator
            events_generator
            step() "env step, called by controller"
            reset() "re-generate a new rail, line and timetable"
            register() "register for event topics"
            deregister() "de-register from event topics"
        }

        class TransitionMap {
            configurations: Set[Configuration] "aka. nodes aka. grid cell entry points"
            transitions: Set[Tuple[Configuration, Configuration]] "aka. edges aka. grid cell transition"
            apply_action_independent()
            get_successor_configurations()
            get_predecessor_configurations()
            is_valid_configuration()
        }

        class Station {
            description: Any
        }

        class Stop {
            description: Any
        }

        class Line

        class LineFlexibleStop

        class Timetable {
            agentTimetables: Map[EnvAgent, AgentTimetable]
        }

        class AgentTimetable {
            line: Line
            initial(): Configuration
            targets(): Set[Configuration]
            timetable: Map[LineFlexibleStop, AgentTimetableItem]
        }

        class AgentTimetableItem {
            earliestArrival: int
            latestDeparture: int
        }

        class FlatlandPolicy {
            <<interface>>
            act()
        }

        class EnvAgent {
            current(): Optional[Configuration]
            next_configuration(): Optional[Configuration]
            offset: Fraction
            timetable: AgentTimeTable
            next_stop(): LineFlexibleStop
        }
    }
    namespace TravelWise {
        class TravelWiseEnv {
            step()
        }
    }

    note for RailEnv "parameterized &lt;Configuration,TransitionMap,Action,Rewards,Observation>"
    note for FlatlandPolicy "parameterized &lt;Observation,Action,Reward>"

```
