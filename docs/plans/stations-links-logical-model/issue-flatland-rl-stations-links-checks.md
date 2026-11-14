<!-- Draft of an issue for a follow-up of flatland-book's docs/plans/stations-links-logical-model.md (§2.2, REQ-5, double-vertex assumption).
Not created on GitHub yet. Title on the first heading line; the rest is the issue body. -->

# Checks for `StationsLinks` and native graphs

**Motivation**

The model relies on properties no code checks (flatland-book's plan `docs/plans/stations-links-logical-model.md`, §2.2):

- Gate and pin names are unique across all stations (`Link`s and `Fibre`s refer to them by name).
- A station's pins are complete: every transition from its area to outside starts at a pin of one of its gates
  (REQ-5). The walk along the line that defines gates stops at the first pin; a missing pin lets it run through the
  station.
- Double-vertex assumption: every move has its reverse at the same resource. Pins, stopping points and fibres hold
  only resources; their entry points and transitions follow from the transition map because of it. It holds on grid
  and for graphs converted from a grid; a natively built graph (`GraphRailEnv.from_graph`) may break it.

**Proposal**

- `StationsLinks.validate(env)` (or a function): unique names; complete pins where a station has an area.
- `GraphRailEnv.from_graph`: check that every edge has its reverse at the same resource (flatland-scenarios PR #36's
  OSM import verifies this already), and raise with the offending edge.

**What changes**

- [ ] The checks, called by the producers' tests and optionally on load.
- [ ] Tests with a duplicate name, a bypass track without a pin, and a graph with a one-way edge.

**Depends on**

The station fields issue, for the check of complete pins (it needs the area).

**Related**

- flatland-book's plan `docs/plans/stations-links-logical-model.md`: §2.2, REQ-5, Q-17. The station fields issue (the area).
