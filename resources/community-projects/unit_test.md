# Real-world relevant uit test benchmark

<!--
How to use this template:
1. Copy this file to resources/community-projects/<your-project>.md (lowercase, dashes, e.g. delay-prediction.md).
2. Replace the title and fill in each section. Replace the instructions (the quoted text starting with ">") with your content.
3. Add your page to _toc.yml below resources/community-projects (next to the template).
4. Add a row for your project to the overview table in resources/community-projects.md.
-->

- **Goal:** _One sentence: what will exist or be known once the project is done?_
- **Status:** _idea / looking for collaborators / ongoing / completed_
- **Contact:** _Name, GitHub handle or e-mail_
- **Tag:** _`project:<short-name>`, e.g. `project:delay-prediction`_

> Use the tag as a GitHub label (or in the title, e.g. `[delay-prediction]`) on all issues and pull requests that belong to this project, in any Flatland
> repository.

## Goal

Create a benchmark consisting of a list of small but domain relevant scenarios describing one specific problem each.

> What do you want to achieve, and why does it matter for Flatland or for railway operations? State the goal so that one can tell at the end whether it
> has been reached, e.g. "Provide a baseline policy that solves all ECML 2026 level 1 scenarios without collisions".

## Description

### Background and Motivation

RL policies sometimes have overall great scores but fail in specific situations. Such situations might be generally underrepresented in random environments or in benchmarks with different goal, or they might have overproportionately large ramifications within the (local) network.

A relevant policy should not only solve the VRSP but also this list of specific scenarios that are relevant for the domain.

> What problem or question are you addressing? Who benefits?

### Approach

Knowledge gathering phase:

- Talk to people who know the domain-specific problems (educators? trainers?)
  - What are problems/scenarios you encounter often (day-to-day)?
  - What are situations with (unexpectedly) large consequences?
- Iterate about how these problems can be integrated as Flatland scenarios
- Exchange with OR/RL researchers to confirm these problems are interesting from their standpoint
  - Some might be provably trivial

Implementation phase:

- Build the scenarios (maybe with varying initial conditions)
- Combine them into a benchmark (motivation, desription, ...)
- Deploy it on Flatland benchmarks

> How do you plan to tackle it? Which methods, tools, data and Flatland components are involved?

### Deliverables

> What will be produced, e.g. code, dataset, scenarios, paper, documentation?

### Scope and First Steps

First step:

- Knowledge phase: learn about such scenarios from domain experts

> What is in and out of scope? What are the first concrete steps?

### Skills Needed

> What kind of help are you looking for?

## Collaboration Procedure

> How will the collaborators work together? Fill in the table below.

| Topic         | Arrangement                                                                              |
| ------------- | ---------------------------------------------------------------------------------------- |
| Meetings      | <!--_e.g. bi-weekly video call, Thursdays 16:00 CET, 45 min_ -->                         |
| Communication | <!--_e.g. channel on the Flatland Discord / Slack, mailing list_-->                      |
| Code and docs | <!--_e.g. repository `flatland-association/<repo>`, issues for tasks, PRs for review_--> |
| Decisions     | <!--_e.g. discussed in meetings, recorded in meeting notes or GitHub issues_-->          |
| How to join   | <!--_e.g. contact the project lead or comment on issue #..._-->                          |

## Collaborators

> Who is involved? Add one row per person.

| Name   | Organisation   | Role                              | Contact          |
| ------ | -------------- | --------------------------------- | ---------------- |
| _Name_ | _Organisation_ | _e.g. project lead_               | _@github-handle_ |
| _Name_ | _Organisation_ | _e.g. contributor, domain expert_ | _@github-handle_ |
