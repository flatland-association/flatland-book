<!-- Draft of an issue for a follow-up of flatland-book's docs/plans/stations-links-logical-model.md (Q-14 revisited, Q-17); step S-4 of
flatland-rl's docs/plans/flatland-scenario-exchange-format.md. Not created on GitHub yet. Title on the first heading
line; the rest is the issue body. -->

# Type `stations_links` by the env's resource and coordinate types, generic for `RailEnv` and `GraphRailEnv`

**Motivation**

`flatland/envs/stations_links.py` (introduced in #441) types every place where the model touches the rail as a cell:
`Pin.node` and `StoppingPoint.node` are `IntVector2D`; `Station.edges` and `Fibre.edges` are `List[IntVector2D]`. This
causes three problems:

- Cells don't exist on a graph, so `GraphRailEnv.stations_links` is always `None`. `from_rail_env` and `from_graph`
  take no stations.
- At a level-free crossing a cell holds two resources, one per axis (`GridResourceMap.get_resource`). A bare cell
  doesn't say which track a pin, a stopping point or a fibre is on.
- Producers have a station key and a placement (the drawing tool's station id and rectangle, sparse's
  `city_positions` and `city_orientations`), but `Station` has no field for them, so `agents_hints` cannot be
  derived from `stations_links`; and a graph built natively (e.g. from OpenStreetMap, flatland-scenarios PR #36) has
  geographic coordinates, not cells.
- The book's Logical Model draws these fields as graph nodes and edges (`FlatlandNode`, `FlatlandEdge`, flatland-book
  [stations and links](https://flatland-association.github.io/flatland-book/environment/environment/stations_links.html),
  PR #44), which matches neither the code nor the env's types.

**Proposal**

Make the model generic in the env's resource type, as `ResourceMap[EntryPointT, ResourceT]` already is, and in a
coordinate type the env gets as a new type parameter. Every rail field holds resources; a station's placement holds a
coordinate:

```python
class AbstractRailEnv(Generic[TransitionMapT, ResourceMapT, EntryPointT, CoordinateT]): ...   # CoordinateT added

@dataclass(frozen=True)
class Placement(Generic[CoordinateT]):
    position: CoordinateT
    orientation: float          # bearing in degrees clockwise from north; b and b + 180 are the same axis
    outline: Optional[List[CoordinateT]] = None   # the drawn shape, a polygon, vertices clockwise

@dataclass(frozen=True)
class Station(Generic[ResourceT, CoordinateT]):
    ...
    id: Optional[int] = None                                   # the producer's key, not the name
    placement: Optional[Placement[CoordinateT]] = None
    display_name: Optional[str] = None                         # shown to people; absent: `name`
    kind: Optional[str] = None                                 # station (absent), stop, junction, crossover, portal

@dataclass(frozen=True)
class StationsLinks(Generic[ResourceT, CoordinateT]): ...
```

| | Grid (`RailEnv`) | Graph (`GraphRailEnv`) |
|---|---|---|
| `ResourceT` | `(r, c)`; `((r, c), d % 2)` at a level-free crossing (`GridResourceMap.get_resource`) | `str` from `GraphResourceMap`; `"(r, c)"`, or `"(r, c, d % 2)"` at a level-free crossing, when converted from a grid (`GraphRailEnv._grid_resource_map`) |
| `CoordinateT` | `(r, c)` | converted from a grid (`from_rail_env`): `(r, c)`; built natively, e.g. from OSM: `(lat, lon)`; `GraphRailEnv` is generic in it |
| Fields | `ResourceT`: `Pin.node`, `StoppingPoint.node`, `Station.area` (replacing `Station.edges`), `Fibre.edges` (and a track, once added); `CoordinateT`: `Station.placement.position`, `Station.placement.outline` | the same |

Entry points and transitions are not stored. They follow from the resources through the env's transition map and
resource map, because every move has its reverse at the same resource (a double-vertex graph; true for grids, graphs
converted from them, and the OSM import of flatland-scenarios PR #36). A stopping point is valid in both directions,
since a train occupies one resource at a time.

On grid this keeps today's cells, except at level-free crossings.

**What changes**

- [ ] `AbstractRailEnv`: the type parameter `CoordinateT`; `RailEnv` binds `Tuple[int, int]`; `GraphRailEnv` stays
  generic in it, and `env.stations_links` is `Optional[StationsLinks[ResourceT, CoordinateT]]`.
- [ ] `stations_links.py`: generic dataclasses, every rail field `ResourceT`, a placement's `position` and `outline`
  `CoordinateT`. The optional fields `Station.id`, `Station.placement`, `Station.display_name`, `Station.kind` and
  `Station.area` (replacing `Station.edges`, the station's rail resources) are added before, typed by cells; here they
  become generic. A fibre's `edges` keeps its name. A station may have no gates and no stopping points (a place
  without tracks along a line).
- [ ] `sparse_rail_generator._extract_stations_links`: at a level-free crossing, the resource of the track's axis;
  `id` the city index, `placement` from `city_positions[i]` and `city_orientations[i] * 90`, `outline` the city
  square's corners, `area` its rail cells (today's `edges`).
- [ ] `GraphRailEnv.from_rail_env` carries `stations_links` over, every resource mapped with `_grid_resource_map`,
  placements unchanged (`(r, c)`).
  `from_graph` takes an optional `stations_links`.
- [ ] A helper returns the entry points and transitions of a pin (inward and outward), a stopping point or a fibre,
  from its resources via the env's maps.
- [ ] Persistence: `stations_links` is pickled as objects (`persistence.py`). Old pickles (no `version`) hold bare
  cells, which differ only at level-free crossings: converted on load, the axis from the transition map. Their missing
  fields read as `None` and their `edges` become `area` already with the station fields.
- [ ] Tests: sparse envs with level-free crossings hold the axis's resource, also when loaded from an old pickle;
  `from_rail_env` keeps `stations_links`; every resource of a converted env is a resource of the graph.

**Open**

- Simplified graphs (`DecisionPointGraph`) merge nodes, so a station's resources may fall inside a merged edge. Not
  covered.

**Not here**

- Drawing geographic placements (`graph/graph_rendering.py:get_positions` uses grid cells only).

**Related**

- #441: introduced `stations_links`.
- The JSON form issue: its schemas for the graph bindings follow from these types.
- The station fields issue: adds the fields typed by cells; this issue makes them generic.
- #129: state/configuration representation.
- flatland-book PR #44: the stations and links page.
