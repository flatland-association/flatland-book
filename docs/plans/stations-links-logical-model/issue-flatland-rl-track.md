<!-- Draft of an issue for a follow-up of flatland-book's docs/plans/stations-links-logical-model.md (Q-11 d), Q-16).
Not created on GitHub yet. Title on the first heading line; the rest is the issue body. -->

# A `Track` element in the stations and links model (future version)

**Motivation**

The model has no track of its own: a stopping point's index stands for its track number. Real numbering (`7A`, `12B`),
several stopping points per track (front and rear of a long platform) and the platform extent cannot be expressed.
flatland-book's plan `docs/plans/stations-links-logical-model.md` decided (Q-11 d)) a `Track` element, and (Q-16)
that it comes in a later version of the format: optional fields, a minor version; the logical model shows it as
«future». Create this issue when that version is planned.

**Proposal** (Q-16's options, a) throughout; decided when the version is planned)

- `Track(name, number: str, extent: List[ResourceT], platform: List[ResourceT])`, name `<station>.<number>`.
- `Station.tracks`; `StoppingPoint.track` refers to its track, serialized by name, so stopping points stay where they
  are and old readers keep working.
- `sparse_rail_generator`: one track per parallel city track, number its index, platform its stop cell. The drawing
  tool: one track per run of platform cells.

**Open**

- The plan's Q-16 records the options with examples: number type, name, extent, platform, where it lives.

**Depends on**

The JSON form issue, released; `Track` comes with `stations_links` 2.1.0.

**Related**

- flatland-book's plan `docs/plans/stations-links-logical-model.md`: Q-11, Q-16. The book page's Haltekante row.
