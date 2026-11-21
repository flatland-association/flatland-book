<!-- Draft of a flatland-ui-hub issue for a follow-up of flatland-book's docs/plans/stations-links-logical-model.md (§8.4, Q-15),
planned in flatland-rl's docs/plans/flatland-scenario-exchange-format.md as step S-9 (§4.7, Q-7 b)). Not created on GitHub yet. Title on
the first heading line; the rest is the issue body. -->

# Station geography from flatland-rl's exchange format, loss free

**Motivation**

`_stations_links_geography` (`app/core/experiment_scenarios.py`) builds the geography from `env.stations_links` in a
`.pkl`: it reads only `Station.name` and the stopping points' nodes, writes `kind: "platform"` and `track` = index + 1,
and drops gates, the area, placements and links. The geography cannot be turned back into stations.

**What changes**

- [ ] An adapter `to_geography(stations_links)` / `from_geography(geography, base)`, reading the format through flatland-rl's (de)serialization:
  `code` ↔ `Station.name`, `name` ↔ `display_name`, `cell` ↔ `StoppingPoint.node`, `kind` ↔ `Station.kind`
  (`platform` ↔ `station`), `via` ↔ `extensions.flatland-ui-hub.via`, `locations` ↔ stations without stopping points
  (column from `placement.position`), `single_track` and `layout` derived from the links.
- [ ] What the geography does not show (gates, area, placements, links, other owners' extensions) stays in the stored
  exchange document next to it: `from_geography(geography, base)` applies the geography onto `base`, so
  `from_geography(to_geography(x), base=x) == x` (exchange-format plan Q-7 b)). The geography is computed on load,
  not stored.
- [ ] Replaces `_stations_links_geography`.
- [ ] Tests: `from_geography(to_geography(x), base=x) == x` for the experiment scenarios, Olten and
  `example-ui-hub-*.json` (flatland-book's plan `docs/plans/stations-links-logical-model.md`, §8.4); for the
  experiment scenarios, the geography equals what `_stations_links_geography` gives today.

**Depends on**

flatland-rl release with the JSON form of `StationsLinks`.
