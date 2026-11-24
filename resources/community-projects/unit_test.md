# Domain-relevant unit test benchmark

<!--
How to use this template:
1. Copy this file to resources/community-projects/<your-project>.md (lowercase, dashes, e.g. delay-prediction.md).
2. Replace the title and fill in each section. Replace the instructions (the quoted text starting with ">") with your content.
3. Add your page to _toc.yml below resources/community-projects (next to the template).
4. Add a row for your project to the overview table in resources/community-projects.md.
-->

- **Goal:** Create a benchmark consisting of a list of domain-relevant scenarios describing one specific problem each.
- **Status:** _idea / looking for collaborators_
- **Contact:** @CleverManu
- **Tag:** `project:unit-test-benchmark`

> Use the tag as a GitHub label (or in the title, e.g. `[unit-test-benchmark`]`) on all issues and pull requests that belong to this project, in any Flatland
> repository.

## Goal

Gather domain-relevant scenarios desribing specific problems or situations that are of special importance. Then, take these scenarios and create a benchmark.

## Description

### Background and Motivation

RL policies can have overall great scores but fail in specific situations. Such situations might be generally underrepresented in random environments or in benchmarks with different goals, or they might have overproportionately large ramifications within the (local) network.

A relevant policy should not only solve the VRSP but also this list of specific scenarios that are relevant for the domain.

### Approach

Knowledge gathering phase:

- Talk to people who know the domain-specific problems (educators? trainers?)
  - What are problems/scenarios you encounter often (day-to-day)?
  - What are situations with (unexpectedly) large consequences?

  _Examples:_
  - _single track segment (ordering / prioritizing)_
  - _crossing multiple tracks in front of a station_
  - _few options to overtake for trains with different speeds_
  - _ensure train connections_

- Exchange with OR/RL researchers to confirm these problems are interesting from their standpoint (some might be provably trivial)

Implementation phase:

- Group scenarios into 'flavors', e.g. scenarios that address the same underlying problem/issue but have varying scales of difficulty or impact
- Define how these problems can be integrated as Flatland scenarios
- Build the scenarios (maybe with varying initial conditions)
- Combine them into a benchmark (motivation, desription, ...)
- Deploy it on Flatland benchmarks

### Milestones & Deliverables

1. Gather domain knowledge to create a list of scenarios with problem descriptions, sketches and reasons why it is on this list [Deliveravle: list of scenarios]
2. Create the benchmark consisting of these scenarios implemented as Flatland scenarios [Deliverable: Flatland scenarios and benchmark]

### Scope and First Steps

First step:

- Knowledge phase: learn about such scenarios from domain experts

Out of scope:

- The unit test benchmark is supposed to consist of _unit type_ scenarios, not larger networks addressing multiple issues at once.

### Skills Needed

Access to people with domain knowledge is needed.

## Collaboration Procedure

tbd...

> How will the collaborators work together? Fill in the table below.

| Topic         | Arrangement                                                                       |
| ------------- | --------------------------------------------------------------------------------- |
| Meetings      | _e.g. bi-weekly video call, Thursdays 16:00 CET, 45 min_                          |
| Communication | _e.g. channel on the Flatland Discord / Slack, mailing list_                      |
| Code and docs | _e.g. repository `flatland-association/<repo>`, issues for tasks, PRs for review_ |
| Decisions     | _e.g. discussed in meetings, recorded in meeting notes or GitHub issues_          |
| How to join   | _e.g. contact the project lead or comment on issue #..._                          |

## Collaborators

tbd...

> Who is involved? Add one row per person.

| Name   | Organisation   | Role                              | Contact          |
| ------ | -------------- | --------------------------------- | ---------------- |
| _Name_ | _Organisation_ | _e.g. project lead_               | _@github-handle_ |
| _Name_ | _Organisation_ | _e.g. contributor, domain expert_ | _@github-handle_ |
