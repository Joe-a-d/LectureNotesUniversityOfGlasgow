# 8 - Build, Release and Dependency Management

<div id="content">

- Build, release and dependency management and interdependent
workflows that ease the process of inter-component change
management by allowing changes to be collated and cached

## Motivation

- software relies on other software, and compiling dependencies can be slow and not totally automatable

- the goal here is to *cache* - release repository - of ready components
 
#### Example tooling

- tools are usually framework specific
  - python : setuptools
  - java : maven, gradle
  - c : make

## Build Management

### Terminology

- **Build Config File** which describes the targets, mapping tasks witin the lifecycle

  - targets : software goals (e.g resolving dependencies, downloading software artifacts)
  - mappings : describe the relation between source and target files since there are usually dependent relations between these (e.g .java -> .class)
  - tasks : actions required to satisfy mappings (e.g execute test suite or run compiler)

rm : build process should be repeatable

e.g : Makefile 
- targets in green
- mappings between the `:`
- tasks in blue

![](@attachment/Clipboard_2020-11-07-18-20-14.png)

### Typical Targets

![](@attachment/Clipboard_2020-11-07-18-21-50.png)

## Dependency & Release Management

Responsible for:
- Establishing requirements
- Obtaining list of available releases for each dependency
- Choose and check feasibility of release version
- Retrieve missing artefacts

### Environmental Dependency

- describe the conditions which must exists around the surrounding software infrastructure so that the software can work

- **Explicit** : can be specified in the config script of the management system (e.g software version)
- **Implicit** : assumed to exist (e.g existence of software)

### Application Dependency

- describe dependencies on other software components (e.g libraries)

### Versioning

- It is useful to include a labelling scheme to describe different releases in the dependency spec

- Each release label should be a ref to a commit

### Specifying Dependencies - Good Practices

- Under constrained : incompatible combinations
- Over constrained : more effort to maintain
- Migrate to new releases when available
- Don't rely on transitive dependencies (e.g those provided by external libraries)

### Types of Release

![](@attachment/Clipboard_2020-11-07-18-40-34.png)

### Release Branch

- Allows devs to prepare a new stable release to a customer, by only incorporating changes that support bug fixes

- New features continue to be developed into master

## Changes to APIs

- The level of visibility of the API determines how the change should be communicated

- Private : documentation is minimal, and shouldn't impact dependencies
- Published : document how changes will affect users
- Public : superset of published ; not explicitly documented as being part of the published API

### Semantic versioning

- one approach to documenting changes in an API

`major.minor.incremental[-tag]`

- e.g : `1.0.3-SNAPSHOT`

- Tag denotes release status, type or other information
- Patch increments denote a non-breaking bug fixing change.
- Minor increments denotes a non-breaking feature addition change.
- Major increments denotes a breaking change to a published API.

### Deprecating Features

- a feature that has been left in place for compatibility reasons, but will be removed from a future release of the wider system

![](@attachment/Clipboard_2020-11-07-18-51-40.png)


</div>
