<!-- Draft of an issue for a follow-up of flatland-book's docs/plans/stations-links-logical-model.md (Q-4 b), Q-8, Q-14 b)).
Not created on GitHub yet. Title on the first heading line; the rest is the issue body. -->

# Optional station area on `Station`, replacing `edges`, and a station outline

**Motivation**

A pin is a resource of the station's area with a transition to outside (flatland-book's plan `docs/plans/stations-links-logical-model.md`, definition of a gate), so gates
depend on where the area's boundary lies. The model has no area: only `Station.edges`. The drawing tool keeps one (a
rectangle); `sparse_rail_generator` has the city square.

**Proposal**

- `Station.area: Optional[Set[ResourceT]]`: the station's rail resources, of the env's resource type (Q-8, Q-14 b));
  its pins lie at its boundary. It replaces `Station.edges`, which is removed: on sparse `edges` equals the rail
  cells of the city square on all 4,320 stations checked, and no code reads it.
- `Placement.outline: Optional[List[CoordinateT]]`: the drawn shape, a polygon, vertices clockwise, the first not
  repeated (grid: the rectangle's corners; a geographic graph: `(lat, lon)`). A bounding box is derived from it.
- Producers fill both: `sparse_rail_generator` the city square's corners and its rail cells; the drawing tool its
  rectangle's corners and the rail inside it.

**What changes**

- [ ] `stations_links.py`: `Station.area` and `Placement.outline`, optional, default `None`; `Station.edges` removed.
- [ ] `sparse_rail_generator`: fill them.
- [ ] Persistence and the exchange format carry them; an old `.pkl`'s `edges` becomes `area` on load.
- [ ] flatland-scenarios: its three test assertions on `edges` (`test_flatland_generators.py:86,127`,
  `model/test_scenario.py:63`) move to `area`.

**Related**

- flatland-book's plan `docs/plans/stations-links-logical-model.md`: Q-4, Q-8, Q-12, Q-14. The checks issue (complete pins need the area).
