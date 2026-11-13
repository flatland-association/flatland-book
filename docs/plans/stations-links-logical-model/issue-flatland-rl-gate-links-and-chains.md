<!-- Draft of an issue for a follow-up of flatland-book's docs/plans/stations-links-logical-model.md (Q-6, Q-9 d)).
Not created on GitHub yet. Title on the first heading line; the rest is the issue body. -->

# Store gate links and chains in `StationsLinks`

**Motivation**

The book's [stations and links](https://flatland-association.github.io/flatland-book/environment/environment/stations_links.html) diagram has `GateLink` (two gates of one station a train passes through) and `Chain`, but
`stations_links.py` implements neither. flatland-book's plan `docs/plans/stations-links-logical-model.md` decided (Q-6) that a `GateLink` is a `Link` within one station.

**Proposal**

- `GateLink(from_gate, to_gate, fibres)`: the fibres from a pin of one gate through the station to a pin of another
  gate of the same station; one fibre per pin pair connected inside the station's area, its `edges` the resources of
  all routes; one gate link per unordered gate pair; `0..` per station (a terminus has none).
- No rule on which pins connect (Q-9 d)): the fibres record it. A reader follows a chain pin by pin.
- `StationsLinks.gate_links` next to `links`. `Chain`: alternating links and gate links.

**What changes**

- [ ] `stations_links.py`: `GateLink`, `Chain`, `StationsLinks.gate_links`.
- [ ] `sparse_rail_generator`: derive gate links from the transition map inside each city.
- [ ] Tests: a gate link's fibres stay inside the station; every in-station pin pair connected by the transition map
  has a fibre.

**Related**

- flatland-book's plan `docs/plans/stations-links-logical-model.md`: Q-6, Q-9 (ECML2026: 61 gate links, 17 partial; sparse: one complete gate link per city).
- The exchange-format plan (flatland-rl `docs/plans/flatland-scenario-exchange-format.md`), Q-13.
