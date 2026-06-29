# Travel Wise

The goal of the [Travel Wise project](https://travelwise-project.eu/) is to improve intermodal coordination and common situational awareness to enable seamless travel across transport modes.

These core ideas will be implemented in Flatland to enable the simulation of Travel Wise sceanrios:

- Multimodality: move from trains-only to other modes of transport (busses, airplanes, ships and ferries, ...)
- Passenger journey: agents can also be people travelling from A to B potentially using multiple modes of transportation
- Graph representation: move from the grid-world to a graph-world in a two-layered representation of an infrastructure-graph and a passenger-graph

## Introduction

The Flatland framework represents a systemic view of a given infrastructure map which is used for dispatching and (re-)routing of trains. With the Travel Wise extensions, a travellers point of view as well as multimodal travel is introduced. With these extensions the concept of connectiong trains and other modes of transportation is introduced alongside new terminology explained in the table below.

| term      | description |
|-----------|-------------|
| journey   | A journey is a travel from point A to point B using potentially different modes of transportation. |
| Itinerary | The itinerary describes the planned route for a given journey. The initial itinerary might be updated during the scenario according to a given metric (default: shortest time). |
| Transfer  | Each change of mode of transportation is a transfer, even if the mode is the same, e.g. from one train to another. |

## High-Level Description

The Travel Wise extensions to the Flatland framework enable to simulate passenger journeys using multiple (different) modes of transportation with corresponding transfers between the different legs of the journey. On such a journey, different milestones are passed. Passing these milestones triggers  communication with a top-layer. This communication layer is the Travel Wise solution (cf. [Travel Wise project](https://travelwise-project.eu/)) and is above and outside Flatland. Travel Wise extensions to Flatland include definition of milestones, the information collected at these events and an implementation to send out these messages to the external layer.

These extensions are realized using a graph representation of the **infrastructure** as a **ground level**. On this level, the agents are trains, buses, plains, etc. (*walkway* is also considered a mode of transportation). As a first implementation, the agent on this level run regardless of passengers and other cargo.

On the **passenger level**, the agents are groups of people (N=1..n) referred to as *passenger*. Each passenger has its own passenger graph on this level. Each passenger graph corresponds to a subgraph of the infrastucture graph (see below). While the infrastructure graph does not change in a given scenario, the passenger graph does change according to available options for their journey.

![Two Layers](./travelwise/two-layers.drawio.png)

A passener, therefore, *hops on* a vehicle running on the infrastructure layer. On each node of the graph where a transfer is possible (stations, stops, airports, ...) the passenger *hops back up* and *sees* the possible paths on its own graph. 

### Goals

The goal is to be able to simulate passenger journeys for a given scenario. A scenario includes both infrastructure with conditinal paths, i.e. edges on the infrastructure graph and schedules with optionally additional data.

### Use Cases

The general use cases are listed here. The Travel Wise scenarios from the project are listed below.

- Generate messages at milestones for a given infrastructure and journey.
- Create an itinerary for a passenger journey for a given infrastructure.
- Update an existing itinerary after a malfunction or delay using a given metric (default: shortest time).
- 

### Data

The data needed to run a scenario:

- Infrastructure
- Optional paths and the conditions under which they can be used
- Schedules of all modes of transportation
- Passenger journeys

Optional data for additional use cases:

- Capacities of (some) modes of transportation
- Additional infrastructure elements
- 

### Requirements Simulation Model



## Travel Wise Scenarios

There are tree Travel Wise scenarios where the first one is split into two parts.

1. **City Pair - Paris-Amsterdam**: Two international airports connected by plane or high-speed train (of wich most connections go trough Brussels).
    - Both paris and Amsterdam are regarded as subscenarios connecting the airport with the interregional train station.
2. **International Hub - Athems**: Airport connected via train, bus and metro with port.
3. **Regional Airport - Bologna**: Airport connected via a monorail with interregional train station and city center.

![Three Travel Wise Scenarios](./travelwise/travel_wise_scenarios.png)

### Data

In addition to the data needed for a general scenario (described above), a Travel Wise scenario also needs:

- Milestones

#### Qualitatively

#### Quantiatively ballpark numbers

### Scientific Questions

## Technical Description Data and Simulation Model

[Traval Wise Data Model](./travelwise/data_model.md)