# Random Graphs

<!--
How to use this template:
1. Copy this file to resources/community-projects/<your-project>.md (lowercase, dashes, e.g. delay-prediction.md).
2. Replace the title and fill in each section. Replace the instructions (the quoted text starting with ">") with your content.
3. Add your page to _toc.yml below resources/community-projects (next to the template).
4. Add a row for your project to the overview table in resources/community-projects.md.
-->

- **Goal:** _Generate random railway network graphs based on metrics/statistics of real networks_ 
- **Status:** _conceptionalization and trial phase, open for collaboration_ 
- **Contact:** _Frederic Noël, [@Partynumbers42](https://github.com/Partynumbers42)_
- **Tag:** _`project:random-graphs`_

> Use the tag as a GitHub label (or in the title, e.g. `[delay-prediction]`) on all issues and pull requests that belong to this project, in any Flatland
> repository.

## Goal

Generate random railway network graphs based on metrics/statistics of real networks. These graphs can then be used as more realistic networks in the flatland framework and to train agents on a randomly generated maps (with specific features). This can make the networks considered more realistic. 

## Description

### Background and Motivation

Currently, Flatland only has random generators working on the grid and works based on heuristics. The output of these generators can then be converted to a graph. In particular, the current generation is not based on quantifiable graph theoretical features. 
With the new graph frameworks in flatland a random generator based on graphs would be very useful on the one hand to allow for random generation to train agents in RL and on the other hand to quantify the realism of the generated train networks, based on to be defined metrics/statistics of real networks.   

### Approach

Potential employment of the Exponential Random Graph Model (ERGM) to generate graphs which copy specific metrics/statistics of a given graph (potentially derived from a real rail network). Collection of inputs from railway experts to find relevant metrics/statistics. 

### Deliverables

Code to generate these random graphs based on given found metrics/statistics. Documentation of generator. 

### Scope and First Steps

Study the theory of Exponential Random Graph Models and understand how generation works. Try out the generation using some random metrics/statistics. Contact experts about relevant metrics/statistics. 

Ultimately, find relevant relevant metrics/statistics & successful generation method and implement it as part of the codebase. 

### Skills Needed

Experience with Exponential Random Graph Models. 
Expert input on relevant metrics/statistics. 

## Collaboration Procedure

| Topic         | Arrangement                                                                       |
| ------------- | --------------------------------------------------------------------------------- |
| Meetings      | _TBD (to be adjusted by demand)_                          |
| Communication | _e-mail (to be adjusted by demand)_                      |
| Code and docs | _TBD after conceptionalization and trials <!---e.g. repository `flatland-association/<repo>`, issues for tasks, PRs for review-->_ |
| Decisions     | _shared overleaf notes (to be adjusted by demand)_          |
| How to join   | _contact the project lead_                          |

## Collaborators


| Name   | Organisation   | Role                              | Contact          |
| ------ | -------------- | --------------------------------- | ---------------- |
| _Frederic Noël_ | _Flatland_ | _project lead_               | _[@Partynumbers42](https://github.com/Partynumbers42)_ |
