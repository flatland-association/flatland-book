Flatland Data Model
===================

## Building Blocks

Flatland represents RL view of the world: agent policies act on the env upon receiving a (partial) observation of the env state.
The world is run by a controller loop and the run is collected in a trajectory.

External effects can be modelled by effects generators, modifying the environment state before or after an env step, reflecting e.g.

- random disruptions of trains (due to door not closing, passenger delaying departure etc.)
- availability of infrastructure (e.g. opening a passenger fast-lane at airports)

The railway domain is reflected at the microscopic level:

* infrastructure/topology is defined by the transition map and stations and stops in the map
* services are defined spatially by lines and spatio-temporally by timetables

The TravelWise extension reflects passenger journeys. Technical, it is an extension of RailEnv, but also refers to an underlying RailEnv where trains, ships
etc. run.

```mermaid
classDiagram
    direction LR
    note for TravelWiseEnv "Agents reflect passengers and configurations represent passenge locations and policies drive passengers; TODO: what are the actions"
    note for RailEnv "Agents reflect trains/ships/etc. Configurations can be graph nodes or grid cell entry points (r,c,d)."
    note for TransitionMap "Topology"
    note for Line "Services in Space"
    note for Timetable "Services in Space and Time"
    note for Agent "TODO: alternatively, this is the next configuration chosen by the action; configuration,next_configuration is then the edge"
    note for Stop "aka. Haltepunkt"
    Journey --> Itinerary: current
    PassengerLocation "1" --> "0..1" Stop
    RailEnv --> TransitionMap
    AgentTimetable "1" --> "1" Line
    AgentTimetable "1" --> "2..." AgentTimetableItem
    AgentTimetableItem "1" --> "1.." AgentTimetableItemAlternative
    TravelWiseEnv --|> RailEnv
    TravelWiseEnv --> "passengers use trains, ships etc." RailEnv

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
            reset() "re-generate a new rail,line and timetable"
            register() "register for event topics"
            deregister() "de-register from event topics"
        }
        class Configuration {
            <<interface>>
        }

        class Station {
            stops: Set[Stop]
        }

        class Stop {
            configuration: Configuration
            meta: Any
        }

        class TransitionMap {
            configurations: Set[Configuration] "aka. nodes aka. grid cell entry points"
            transitions: Set[Tuple[Configuration, Configuration]] "aka. edges aka. grid cell transition"
        }

        class Timetable {
            agentTimetables: List[AgentTimetable]
        }

        class AgentTimetable {
            line: Line
            initial(): Configuration
            target(): Configuration
            current(): Optional[Configuration]
        }
        class AgentTimetableItem
        class AgentTimetableItemAlternative {
            stop: Configuration
            earliestArrival: int
            latestDeparture: int
        }

        class Line {
            stops: List[[List[Stop]]]
        }

        class Station {
            stops: Set[Stop]
        }

        class FlatlandPolicy {
            <<interface>>
            act()
        }

        class Agent {
            configuration: Configuration
            next_configuration: Configuration
            offset: Fraction
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

## JSON Representation

https://github.com/flatland-association/flatland-rl/issues/129

### Environment State

```json
{
  "meta": {
    "version": 0.1,
    "type": "Flatland Digiial Environment State"
  },
  "rail": {
    "topology": {
      "type": grid
      or
      graph,
      "configuration": {
        type-dependent
        representation
      }
    },
    "stations": {
      todo
      details
    },
    "lines": [
      {
        "waypoints": [
          for
          all
          lines
          list
          of
          waypoints
          with
          flexibility
        ]
        "stations": [
          {
            "rail_elements": [],
            "
          }
        ]
      }
    ],
    "timetable": [
      {
        "earliest": int,
        "latest": int
      }
    ],
    "agents": {
      "position": position/direction/counter
      or
      edge/offset,
      "max_speed": float [
  0,
  1
]
"speed": float [0, 1]
"malfunction": int
"state": enum
"line": },
"internal": {
"elapsed_steps": int,
}
}
```

### Environment Configuration

```json
{
  "meta": {
    "version": 0.1,
    "type": "Flatland Digitial Environment Configuration"
  },
  "reset_generators": {
    "rail": {
      "type": Python
      class
      or
      identifier
      to
      be
      more
      refactoring
      safe,
      "configuration": kwargs
    },
    "line": {},
    "timetable": {}
  },
  "effects_generators": [
    {
      "including malfunction"
    }
  ],
  "rewards": {
    "type": fully-qualified
    class
    or
    identifier,
    "configuration": kwargs
  },
  "params": {
    "acceleration_delta": 1.0,
    "braking_delta": -1.0,
    "observation_builder": type
    with
    no
    args
    state
    to
    any,
    "info_builder": type
    with
    no
    args
    state
    to
    dict
    "remove_agents_at_target": True,
    "max_episode_steps"
  }
}
```

## Open Questions

- Term journey?
- Term itinerary?
- Term/concept milestones?
- Term/concept connection?
- actions in TravelWiseEnv?
- controller output not only defines next configuration
- stats level?
- detail add effects generators and events
- detail harmonize data model with math formulation
- Do we need concept of Intention/chosen path? Where? How represented? Is this itinerary
- update JSON according to class view
