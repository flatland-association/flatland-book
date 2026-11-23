<!-- Draft of an issue for a follow-up of flatland-book's docs/plans/stations-links-logical-model.md (Q-7 c), Q-10).
A future extension: create it only when a producer or consumer needs a priority. Not created on GitHub yet. Title on
the first heading line; the rest is the issue body. -->

# Priority on fibres (future extension)

**Motivation**

flatland-book's plan `docs/plans/stations-links-logical-model.md` decided (Q-7 c)) that fibres cover all pin-to-pin
connections of the topology: connections that should not be used normally (a crossover against the main direction,
a route across all tracks of a station) are kept, not left out. Marking them is deferred (Q-10): the model has no
priority yet, so all fibres are equal.

**Proposal** (when it is needed)

- An optional field on `Fibre`, in links and gate links alike, whose absence means normal, so files and readers
  without it stay valid.
- Until then, a producer that needs one puts it in the fibre's extension data (the exchange format's extension
  mechanism, plan Q-13); once it proves general it moves into the core with a new schema `version`.

**Open** (decided when it is added)

- Scale: an ordinal number (lower preferred, `0` normal), a few named levels (`preferred`, `normal`, `avoid`), or a
  cost a planner adds up.
- Scope: compared within one link or gate link, or across the network.
- Who sets it: the drawing tool (a user lowers a pin pair's priority); `sparse_rail_generator` sets none.

**Depends on**

The JSON form issue, released (until then a priority is extension data). Create it only when a producer or
consumer needs a priority.

**Related**

- flatland-book's plan: Q-7, Q-10, DP-10 (extensible without breaking readers). The gate links issue.
