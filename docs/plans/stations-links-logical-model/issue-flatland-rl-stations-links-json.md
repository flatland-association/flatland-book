<!-- Draft of an issue for a follow-up of flatland-book's docs/plans/stations-links-logical-model.md (Q-13, §8.3); step S-2 of
flatland-rl's docs/plans/flatland-scenario-exchange-format.md. Not created on GitHub yet. Title on the first heading
line; the rest is the issue body. -->

# A JSON form and a generated schema for `StationsLinks`

**Motivation**

The drawing tool, flatland-scenarios and flatland-ui-hub each convert stations their own way. One JSON form owned by
flatland-rl, with a schema as the contract, removes those converters (flatland-book's plan `docs/plans/stations-links-logical-model.md` (flatland-book PR #45), its Q-13 and §8.3).

**What changes**

- [ ] `StationsLinks.to_dict()` / `from_dict(d)`: dataclasses as JSON objects, tuples as lists, pin keys as strings,
  `None` fields left out, deterministic key order; `version` (`"2.0.0"`), `binding` (`"grid"`) and `extensions_used`
  at the top, then `stations`, `links`, `gate_links`.
- [ ] `extensions` on every element, keyed by owner; owners declared in `extensions_used`.
- [ ] `gate_links` written and read once `StationsLinks.gate_links` exists (the gate links and chains issue); optional in the schema.
- [ ] The grid binding's JSON schema, generated from the dataclasses
  (`flatland/envs/schemas/stations_links.grid.schema.json`), fixing `binding` and the resource type; the
  conventions in its descriptions. A `Link` may start and end in the same station.
- [ ] Once `stations_links` is generic (the generic types issue): the `graph` and `graph-geo` bindings' schemas,
  generated the same way.
- [ ] Tests: `from_dict(to_dict(x)) == x` for hand-written and sparse stations; the schema validates them and the book
  plan's `example-grid.json`, accepts an owner's extension and refuses a graph document; later the graph schemas
  validate `example-graph.json` and `example-graph-geo.json`.

**Depends on**

The station fields issue.

**Related**

- #129: the scenario format builds on this.
