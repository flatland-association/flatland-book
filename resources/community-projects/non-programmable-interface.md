# Project Template

<!--
How to use this template:
1. Copy this file to resources/community-projects/<your-project>.md (lowercase, dashes, e.g. delay-prediction.md).
2. Replace the title and fill in each section. Replace the instructions (the quoted text starting with ">") with your content.
3. Add your page to _toc.yml below resources/community-projects (next to the template).
4. Add a row for your project to the overview table in resources/community-projects.md.
-->

- **Goal:** Make flatland features and frameworks available to non-programmers through a natural language interface.
- **Status:** idea
- **Contact:** _Name, GitHub handle or e-mail_
- **Tag:** `project:npi`

> Use the tag as a GitHub label (or in the title, e.g. `[npi]`) on all issues and pull requests that belong to this project, in any Flatland repository.

## Goal

To use flatland today, you need some programming skills.
We want to make flatland accessible to a broader, non-technical audience:
- people interested to understand how machine learning and simulations work, e.g. students
- people interested or working in railway
- people new to railway capacity management
- people exploring new appraoches to capacity management, in particual timetable generation and dispatching
Users learn how flatland works conceptually, what they can and cannot do with it, and can deliberitely design experiments with sensible results.
The interface should be usable without any commercial LLM.
7 out of 10 test users can build and run a flatland simulation trough the interface.

## Description

### Background and Motivation

> What problem or question are you addressing? Who benefits?

### Approach

> How do you plan to tackle it? Which methods, tools, data and Flatland components are involved?

### Deliverables

> What will be produced, e.g. code, dataset, scenarios, paper, documentation?

### Scope and First Steps

Make the core functionality (env definition, sim with existing policy, evaluate results, train model) accessible through a chat interface.

The scope is split into for parts with growing complexity:
1. set up and running envs
2. train a basic model
3. define observations, rewards, and model architecture
4. run benchmarks

An mvp should include part 1 and 2, and explain the funcitonality through tutorials, knowlege base, etc.

The interface is limited to existing features and not a general programming interface.

First steps:
- Define the basic test cases users should be able to fulfill.
- Define setup for interaction with LLM or other approach for handling natural language input.
- Define roadmap incl. how to test with users.

### Skills Needed

> What kind of help are you looking for?

## Collaboration Procedure

> How will the collaborators work together? Fill in the table below.

| Topic         | Arrangement                                                                       |
| ------------- | --------------------------------------------------------------------------------- |
| Meetings      | _e.g. bi-weekly video call, Thursdays 16:00 CET, 45 min_                          |
| Communication | _e.g. channel on the Flatland Discord / Slack, mailing list_                      |
| Code and docs | _e.g. repository `flatland-association/<repo>`, issues for tasks, PRs for review_ |
| Decisions     | _e.g. discussed in meetings, recorded in meeting notes or GitHub issues_          |
| How to join   | _e.g. contact the project lead or comment on issue #..._                          |

## Collaborators

> Who is involved? Add one row per person.

| Name   | Organisation   | Role                              | Contact          |
| ------ | -------------- | --------------------------------- | ---------------- |
| _Name_ | _Organisation_ | _e.g. project lead_               | _@github-handle_ |
| _Name_ | _Organisation_ | _e.g. contributor, domain expert_ | _@github-handle_ |
