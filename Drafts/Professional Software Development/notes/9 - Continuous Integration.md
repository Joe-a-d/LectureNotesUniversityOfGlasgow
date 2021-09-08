# 9 - Continuous Integration

Continuous integration is a collection of practices that are designed to minimise the disruption to a project caused by change. In addition, CI practices provide a mechanism for actively monitoring the quality of a software system as it evolves

# Integration Hell

- a situation where a dev spends more time trying to itegrate source code than they did creating the new feature. Due to:
  - concurrent breaking changes
  - conflicts with the new features 
  - integrating very large changes to code base in one go
  - infrequent integrations

# Practices

- Fowler, 2006
- Change management
  - single source repo
  - daily commits to master
  - every commit builds master on an integration machine
  - everyonce can see what's happening
- QA
  - automate the build
  - self-testing builds
  - test in a clone of production
  - keep builds fast
- Deployment
  - easy access to latest executable
  - automate

## Change Management

- late integration approach to new features
  - devs work on separate copy of the source code within an iteration
  - once a feature is completed changes to the code are reintegrated into the main trunk
  - conflicts arise, since everyone tries to reintegrate at the same time
- Note how the trunk in the left image diverges from the baseline faster than the feature branch, beacuse the trunk represents the effort of every other dev making smaller commits than a whole new feature (defect fixed, enhancements etc)
  - hence, when the branch dev is ready to re-integrate there is much more work to do
- On the other hand, the image on the right shows how by dividing the work into smaller chunks the changes can be integrated much more frequently, limiting the divergence from the shared master and therefore the amount of work at time of re-integration

![](@attachment/Clipboard_2021-07-09-20-40-37.png)

## Feature Branching

- in its pure form, CI doesn't allow branching, since all devs should make small, frequent commits to the trunk
- feature branches however allow for experimenting with longer term proposals. These can be implemented by compromising strategies between the branches and the trunk
  - implement the new feature on the trunk , with frequent commits of small changes (purist)
  - implement the new feature in a branch and merge changes from the trunk frequently
    - medium-term feature branches that are of low uncertainty
  - implement a feature as a prototype branch and then re-implement the feature on the trunk in small changes
    - allows the branch to diverge as much as needed ; high-risk features
  - implement the feature as a permanent branch
    - the branch effectively becomes a separate trunk, while still maintaining a similar code base with the parent project

### Maintaining multiple CI processes

- in the case where a project is maintaining a number of different branches, it makes sense to consider using multiple processes
  - the longer-live the branch, the more important it is to setup a separate CI process
  - e.g. mainline for new features and defect fixes ; fault-development ; latest stable for only defect finding and fixes

# Monitoring and Maintaining Software Quality

- uncontrolled high frequency integration could lead to a large number of defects being introduced , hence QA should be employed with equivalent frequency
  - commit
  - build
    - if fail : consider the build broken and make fixing it **the highest priority task** ; commits should cease until this happens
- detecting broken builds
  - compile from source in production clone
  - run automated regression tests
  - static analysis checks

- broken builds should be rare, since private builds should be undertaken before committing to public repo

![](@attachment/Clipboard_2021-07-09-20-58-20.png)
![](@attachment/Clipboard_2021-07-09-21-00-02.png)

## Staging Environments

- a staging platorm is an environemnt confgured to replicate/simulate the conditions the software will be used in
- **limitations**
  - system will be distributed on too many computing nodes to test realistic scenarios
  - too many different platform configs
  - too many simultaneous users
  - too many diverse user types fro all to be tested
  - software dependencies cannot be accessed from outside of production

## CI Envrionments

- used to configure and execute a CI pipeline
  - e.g. Jenkins, Gitlab Runner, Travis CI ...
- used in conjuction with a VC system and automated build system
- configured to manage a number of jobs

### Workflow

![](@attachment/Clipboard_2021-07-09-21-04-24.png)

### State Visibility

- push notifications (e.g. email)
- broadcast mechanisms such as a display status monitor on a large screen display in the dev area
- metrics
  - unsuccessful builds
  - average unsuccessful tests
  - time to build

### Importance of Fast Builds

- delays in build imply delay in problem detection
- deter devs from making frequent commits, because having to wait for a build will reduce productivity
- recommended time is 10m
  - as the project grows this becomes harder to comply with. However, several compromises can be agreed on
    - reconfigure the build process to remove unnecessary steps
    - break the build into separate builds responsible for testing different parts of the project, so that only changes that affect that part of the project trigger that build. (daily builds of the whole system are still required)
    - review selection of tests as new features are added
    - partition larger projects into smaller well defined components that can be developed concurrently