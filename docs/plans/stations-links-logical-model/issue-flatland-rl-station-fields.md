<!-- Draft of an issue for a follow-up of flatland-book's docs/plans/stations-links-logical-model.md (Q-4 b), Q-8, Q-12 d), Q-14 b), Q-15).
Not created on GitHub yet. Title on the first heading line; the rest is the issue body. -->

# Station fields on `Station`: id, placement with outline, area replacing `edges`, display name and kind

**Motivation**

- A pin is a resource of the station's area with a transition to outside (flatland-book's plan
  `docs/plans/stations-links-logical-model.md`, definition of a gate), so gates depend on where the area's boundary
  lies. The model has no area: only `Station.edges`. The drawing tool keeps one (a rectangle); `sparse_rail_generator`
  has the city square.
- Producers have a station key and a placement (the drawing tool's station id and rectangle, `sparse_rail_generator`'s
  `city_positions` and `city_orientations`), but `Station` has no field for them, so `agents_hints` cannot be derived
  from `stations_links`.
- flatland-ui-hub shows a display name next to a short code, and places of other kinds (stops, portals, junctions);
  `Station` has only `name`.

**Proposal**

- `Station.id: Optional[int]`: the producer's own key, not the name (Q-12 d)).
- `Station.placement: Optional[Placement]` (grid coordinates for now; generic with the typing issue): where the station is drawn (Q-12 d)): `position` (the reference
  coordinate; grid: the reference cell, as `agents_hints`), `orientation` (a bearing in degrees clockwise from north;
  `b` and `b + 180` are the same axis; grid `0`, `90`, `180`, `270`), and `outline: Optional[List[IntVector2D]]` (`CoordinateT` with the typing issue): the
  drawn shape, a polygon, vertices clockwise, the first not repeated (grid: the rectangle's corners; a geographic
  graph: `(lat, lon)`). A bounding box is derived from the outline.
- `Station.area: Optional[Set[IntVector2D]]`: the station's rail cells, the env's resource type with the typing issue (Q-8, Q-14 b));
  its pins lie at its boundary. It replaces `Station.edges`, which is removed: on sparse `edges` equals the rail
  cells of the city square on all 4,320 stations checked, and no code reads it.
- `Station.display_name: Optional[str]`: the name shown to people; `name` stays the key of the qualified names (Q-15).
- `Station.kind: Optional[str]`: `station` when absent, `stop`, `junction`, `crossover`, `portal`, or `<owner>:<value>`
  for a producer's own; a reader treats an unknown value as `station` (Q-15). A station may have no gates and no
  stopping points (a place without tracks along a line).
- The module docstring states the grid conventions: cells `(row, column)`, Grid4 directions with N = `row - 1`, gate
  keys by side and heading of a leaving train, one stopping point per track.
- Producers fill them: `sparse_rail_generator` `id` the city index, `placement` from `city_positions[i]` and
  `city_orientations[i] * 90`, `outline` the city square's corners, `area` its rail cells; the drawing tool its
  station id, its rectangle's corners and the rail inside it.

**What changes**

- [ ] `stations_links.py`: `Station.id`, `Station.placement` (`Placement` with `position`, `orientation`, `outline`),
  `Station.area`, `Station.display_name`, `Station.kind`, optional, at the end, default `None`; `Station.edges`
  removed; the conventions docstring.
- [ ] `sparse_rail_generator`: fill `id`, `placement` and `area`.
- [ ] Old pickles load: missing fields read as `None`, `edges` becomes `area` (`__setstate__`).
- [ ] flatland-scenarios: its three test assertions on `edges` (`test_flatland_generators.py:86,127`,
  `model/test_scenario.py:63`) move to `area`.
- [ ] Tests: sparse stations carry the fields; `agents_hints` is derivable from `id` and `placement`; an old `.pkl`
  loads with `area`.

**Related**

- flatland-book's plan `docs/plans/stations-links-logical-model.md`: Q-4, Q-8, Q-12, Q-14, Q-15. The checks issue
  (complete pins need the area).
- The JSON form issue (their JSON form) and the generic types issue (typing them by the env's resource and
  coordinate types).
- flatland-rl's plan `docs/plans/flatland-scenario-exchange-format.md`: step S-1.
