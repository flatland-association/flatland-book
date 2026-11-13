<!-- Draft of an issue for a follow-up of flatland-book's docs/plans/stations-links-logical-model.md (Q-2 a), Q-14 b), Q-19, REQ-5).
Not created on GitHub yet. Title on the first heading line; the rest is the issue body. -->

# Drawing tool: gates by the corridor rule, complete pins, links

**Motivation**

flatland-book's plan `docs/plans/stations-links-logical-model.md` defines a gate by the corridor rule (Q-1 d)): the pins of one side that link to the same gates along the line,
up to the first pin. The tool groups a side's pins into one gate (PR #39 plan S-19), which breaks the rule where a
side's lines lead to different gates (ECML2026: 10 of the tool's 71 gates; 81 gates after the split). Its pins come
from the tracks reached from the platforms (`stationTracks`), so a track crossing the area without a connection to a
platform gets no pin (REQ-5 there). The tool exports no links yet.

**Proposal**

- Pins: every track crossing the area's boundary, not only those reached from the platforms; or report a missing one
  when an area is saved, next to `stationAreaError`.
- Export (Q-14 b)): the station's `area` is all rail inside the rectangle (a through track included), no `edges`; the
  rectangle goes to `placement.outline` as its four corners.
- Gates: start from one gate per side and split by the gates the pins link to, until nothing changes; keys `N1`,
  `N2`, … The tool follows each pin's track outward to the first pin it meets.
- Links: one per unordered gate pair, fibres per connected pin pair; a loop back to the own station is a `Link` too
  (Q-19).

**What changes**

- [ ] `flatland_environment_drawing_tool.html`: `stationTracks`/`stationGates`, a links export, the area check.
- [ ] README: gates, links, the area check.
- [ ] Tests (the repo has no JS tests yet).

**Related**

- flatland-book's plan `docs/plans/stations-links-logical-model.md`: §4.3, Q-1–Q-3, Q-19, REQ-5.
- flatland-scenarios PR #39 and its plan (Q-2 revisited).
