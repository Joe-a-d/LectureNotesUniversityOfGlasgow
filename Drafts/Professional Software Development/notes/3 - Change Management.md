# 3 - Change Management

# Motivation

- when working in a team sharing a codebase it's crucial so that everyone is looking at the same codebase

# Change Control Items

- any artifact that the SE might directly edit. e.g.
  - source code
  - config 

# Version Control

- software tool for maintaining the history of changes to a set of change control items (e.g. Git)
- Core workflow (regardless of tool)
  - local changes to the working copy
  - receive updates from remote (pull)
  - resolve conflicts
  - submit changes to remote (push)

## Centralised vs Distributed

- centralised
  - single source of truth
- distributed
  - each working copy is linked to a repo
- hybrid (forking)
  - mix of both
  - most common nowadays
  - makes use of a master which is linked to repos linked to individual working copys
  - **advantage** : single source of truth but also allows local commits to individual repos before commiting to master

![](@attachment/Clipboard_2021-07-07-01-16-36.png)

## Commits

- a complete snapshot of the project at that time
  - though only changes since previous commit are recorded

### Log messages

- good commits are essential for team coordination and cohesion
- each team may agree on their own standard (often using a template) but the following are good practice to include
  - intent of a commit
  - single purpose changes
  - link to the the backlog task
  - explain how the commit addresses the issue
  - short, meaningful title

## Branching

- allows multiple dev lines within the same repo based on a common history (e.g. dev branch, master branch, feature branch)
- its usually best practice to give meaningful names to branches
  - in particular for feature branches a hierarchical structure should be used , *feature/app_name/feature_name*
- several widely used workflow templates are available nowadays
  - e.g. gitglow, gitlab flow etc.

### Trunk Based


- simplest, clear
- reduces risk of merge conflicts
- increase risk of broken code in the main branch (-)


### Feature

- greater freedom to experiment without breaking master
- easier to manage code reviews prior to merge to master
- encourages longer periods between integration (-)
- conflicts more likely

### Staging

- allows changes to be tested in a user acceptance testing environment
- merging can be automated once tests pass
- some teams use a UAT environment for every feature branch, turning them effectively into staging branches

## Misusing VC - Storing non-Config items in repo (bad smells)

- version control repo should not be seen as a file store
- e.g. 
![](@attachment/Clipboard_2021-07-07-01-34-55.png)

- instead a *release and dependency management* strategy should be used (covered later in the course)