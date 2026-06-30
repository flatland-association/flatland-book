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

## Tentatively/Partially Resolved

- Term/concept milestones? -> event generator, conditional events,
    - milestone: delay at arrival, departure, opening of fast track
- TravelWiseEnv hypothesis:
    - motion check: optional if not shared, potentially capacity, not mutex but semaphore?
    - query view on infrastructure timetables: gives a set of itineraries, which can be prioritized according to preferences; graph represents these
      itineraries, the possible "paths" and not the infrastructure, the graph can change when itineraries become impossible or (better) options arise (I can
      catch a delayed train); each agent has their own (disjoint) sub-graph it is running on; optimization/performance issue: when do we need to update the
      graph(s)?
    - actions in TravelWiseEnv: choose from a set of itineraries or choose between up to 5 (?) next at decision points?
- Term journey
    - passenger wants to go from A to B at T. -> synonym of Schedule, no need for new concept.
- Term/concept connection?
    - Use `transfer` for passenger level, transfer between rides
    - Use `connection` for the IM/RU side, for the commercial offering, what's the timetable -> not relevant for TW
    - Used for rewards/evalution? Derived from agent's preferred itinerary? Initially preferred? Stil unclear how used.

## Work Packages and Tasks

- Graph Simulation:
    - Generalization core to work on abstract configurations instead of grid-based coordinates, incl. rewards
        - core: step, configurations -> edges or nodes + direction/action?
      - rewards
          - distance map etc.?
      - observation builder
          - Trajectory API
          - DLA/baselines
    - finalize data and math model
    - potentially implement persistence according to this finalized model
- Infrastructure Graph
    - Import of rail data
    - Import of line/timetable data
    - Modelling of foot transfers
  - Agent subgraph view on infrastructure graph conditional on edge attributes (transport mode, fast lane open for X) and agent attributes (transport mode,
    agent ID)
- Passenger Graph
    - Import of passenger journeys
    - Implementation of itineraries
        - Implementation of timetable query on the underlying infrastructure graph.
  - Hooking into infrastructure graph (hopping on/off a vehicle) to update the itinerary, resp. update position on graph
      - Definition of actions for this Flatland environment.
  - Either separate graphs for each agent or introduction of
      - edge capacities (1 for infrastructure layer, high for passenger layer)
      - mutex on/off (on for infrastructure layer, off for passenger layer)

- Milestones
    - Conceptual definition of milestones for each use case
    - Implementation of milestones as policy runner callbacks or effects generators to detect milestone events
    - Definition of the event payload
    - Implement sending (generalization of Interactive AI callback): async queue that sends out REST calls/RabbitMQ messages etc.
- Fast Lanes:
    - Implementation of effects generator opening/closing fast lanes, probably offline, potentially online (integration with TW solution)

### Priorities, PoCs/spikes

- graph simulation fully working
- refine use cases: data imports and graph modelling
- milestones conceptuatl definition
- passenger graph/itinerary: refine conceptual work and PoC for passenger graph/itinerary builder for passenger journey from infrastructure graph
- PoC/skeleton TW environment hooking into RailEnv

## Discussion, Open Questions

- Is it really a subgraph? For passenger decisions, this is time-based, so multiple passenger edges might map to the same infrastructure edge! Is it a
  location-based infrastructure graph as well or does it reflect the timetable options (arrival at 11.00, so outgoing edges start not before 11.00, but multiple
  might go over the same infrastructure?)
- Term itinerary?
    - Is itinerary the passenger graph or a choice of decisions based on this graph?
    - controller output may not only define next configuration, but full "path", see above Is this a generalization of actions or something else?
        - how does this harmonize with RailEnv's timetable concept?
    - how does this relate to existing prediction builder (used in tree obs)
- How simple can the queries from top to bottom layer be? Problem: logic in query, observation builder not functional any more (anti pattern: passing through
  query to env to observation to return as observation next)
- Can we have data, make examples? What are the sizes full etc. Which simplifications on topology and schedule.
- Elephant in the room: what are the actions on the graph?
