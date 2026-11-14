<!-- Draft of an issue for a follow-up of flatland-book's docs/plans/stations-links-logical-model.md (Q-2 a), Q-5, Q-19).
Not created on GitHub yet. Title on the first heading line; the rest is the issue body. -->

# `sparse_rail_generator`: gates by the corridor rule, links derived from the transition map

**Motivation**

The book's [stations and links](https://flatland-association.github.io/flatland-book/environment/environment/stations_links.html) page defines a gate by the corridor rule (flatland-book's plan `docs/plans/stations-links-logical-model.md`, Q-1 d), Q-18 b)): the pins of one side of a
station that link to the same set of gates along the line, up to the first pin. `sparse_rail_generator` makes one
gate per city side (`_extract_stations_links`), which breaks the rule for 1,075 of 8,640 gates (810 envs: 30 seeds ×
3/5/8 cities × 1-3 rail pairs × 1-3 rails between cities, 60×60). Its links are the lines as built: one per
direction, and fibres per drawn line (3,627 of 11,982 pins disagree with the transition map), and no link for a line
that loops back to its own city.

**Proposal**

- **Gates:** start from one gate per side, then split each gate by the gates its pins link to, adjacent or not,
  until nothing changes (Q-2 a), Q-3 b)). The result does not depend on the order. Keys `N1`, `N2`, … for a split side.
- **Links:** derive them from the transition map: one fibre per pin pair connected along the line (the first pin met
  after leaving the station), its `edges` the resources of all routes between the two pins; one link per unordered
  gate pair (Q-5). A line that loops back to its own station is a `Link` too, between two of its gates or from a gate
  to itself (Q-19).

**What changes**

- [ ] `rail_generators.py` `_extract_stations_links`: the split, and links derived from the transition map.
- [ ] A shared helper (e.g. in `stations_links.py`) that derives links and splits gates for any producer.
- [ ] Tests: every gate satisfies the corridor rule; every connected pin pair has one fibre; loops become links.

**Breaking**

Gate names change where a side is split (`A.N` → `A.N1`, `A.N2`), and link counts change (one per gate pair instead
of one per direction). Readers that address gates by name, or count links, see different data.

**Depends on**

The station fields issue (the area) and the gate links issue.

**Related**

- flatland-book's plan `docs/plans/stations-links-logical-model.md`: §4.3 (the rule and the checks), Q-1–Q-3, Q-5, Q-18, Q-19.
- The typing issue (stations links by the env's resource type).
