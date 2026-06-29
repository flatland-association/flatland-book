# Travel Wise

The goal of the [Travel Wise project](https://travelwise-project.eu/) is to improve intermodal coordination and common situational awareness to enable seamless travel across transport modes.

These core ideas will be implemented in Flatland to enable the simulation of Travel Wise sceanrios:

- Multimodality: move from trains-only to other modes of transport (busses, airplanes, ships and ferries, ...)
- Passenger journey: agents can also be people travelling from A to B potentially using multiple modes of transportation
- Graph representation: move from the grid-world to a graph-world in a two-layered representation of an infrastructure-graph and a passenger-graph

## Introduction

The Flatland framework represents a systemic view of a given infrastructure map which is used for dispatching and (re-)routing of trains. 

## High-Level Description

The Travel Wise extensions to the Flatland framework enable to simulate passenger journeys using multiple (different) modes of transportation with corresponding transfers between the different legs of the journey. On such a journey, different milestones are passed, meaning a form of communication with a top-layer (which is above and outside Flatland) is extablished. This communication layer is the Travel Wise solution (cf. [Travel Wise project](https://travelwise-project.eu/)).

These extensions are realized using a graph representation of the **infrastructure** as a **ground level**. On this level, the agents are trains, buses, plains, etc. (*walkway* is also considered a mode of transportation). As a first implementation, the agent on this level run regardless of passengers and other cargo.

On the **passenger level**, the agents are groups of people (N=1..n) referred to as *passenger*. Each passenger has its own passenger graph on this level which is a subgraph of a projection of the infrastucture graph (see below).

![Two Layer](./travelwise/two-layers.png)

A passener, therefore, *moves* down to the infrastructure graph to move along edges. On each node of the graph where a transfer is possible (stations, stops, airports, ...) the passenger hops back up and *sees* the possible paths on its own graph.

### Goals

The goal is to be able to simulate passenger journeys for a given scenario. A scenario includes both infrastructure with conditinal paths and schedules with optinally additional data.

### Use Cases

The general use cases are listed here. The Travel Wise scenarios from the project are listed below.

- Generate messages at milestones for a given infrastructure and journey.
- Create an itinerary for a passenger journey for a given infrastructure.
- Update an existing itinerary after a malfunction or delay using a given metric (default: shortest time).
- 

### Data

The data needed:

- Infrastructure
- Optional routes and the conditions under which they can be used
- Schedules of all modes of transportation
- Example journeys for different passengers

Optional data for additional use cases:

- Capacities of (some) modes of transportation
- Additional infrastructure elements
- 

### Requirements Simulation Model



## Travel Wise Scenarios

### Data

#### Qualitatively

#### Quantiatively ballpark numbers

### Scientific Questions

## Technical Description Data and Simulation Model

[Traval Wise Data Model](./travelwise/data_model.md)