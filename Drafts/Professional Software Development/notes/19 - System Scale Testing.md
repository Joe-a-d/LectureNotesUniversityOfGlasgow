# 19 - System Scale Testing

Non-Functional Requirements
: emerging properties of an overall system that must be measured to be satisfied rather than being obeserved as a provided feature

NFR cannot be checked by statistical analysis tool, they can only be checked after implementation. The implementation can be the final system or a prototype.

## Testing Process

- similar to science experiment
  - create hypothesis
  - define property to be measured
  - metric to be used
  - operating conditions in which the requirement must be satisfied
  - threshold the system behaviour must exceed to satisfy the requirement

- there are different categories of NFR , each one can be tested in different ways. Below is a overview of some of the categories


## Safety Critical Environments

- Software whose malfunction can cause severe damage to its users or the system itself

EXAMPLES
  - autopilots
  - space based tech
  - nucalear power station management systems

Safety Critical
: 

## Reliability Testing

- The extent to which the system behaves according to its specification. This can be measured by (e.g) the following metrics:
  - Prob failure on demand : estimate of prob of failure each time system is accessed
  - Mean Time to Failure : how long till failure since init or avg time between failures (useful metric for systems which are hard to access for repairs, e.g. space systems)
  - Down Time : How much time can be lost to sytem outages over a period of time (e.g. payment systems are often designed to have less than few seconds per year)


### Methods

- Model Driven Dev : Implementation of software and test suite to be generated automatically from platform indep models ; test cases are derived from assertions describing legal and illegal states of the model

- Cleanroom Dev : Uses automated and stats methods to select test cases for execution ; used to calc an estimate of the prob of failure on demand and a confidence in the estimate


- Hazards and Operability Analysis (HAZOPS) : derived from chemical engineering ; identify flows of information between software components; questions can be asked how the flows of information are made


The emphasis on formal methods for testing is to gain accurate measurements as to the reliability of the system, i.e to provide inputs into a safety case (justifications that the system meets safety requirements). HAZOPS on the other hand, is to explore the consequences of failure if one or more components do not perform as expected

## Hostile Environments

- assumed to contain active agents whose goal is to subvert a deployed system (e.g electronic voting systems, ATMs etc)

### Security Testing Metrics

- attacker know-how
- time and resources to penetration
- unpatched vulnerabilities
- attack surface exposure


### Methods

- vulnerability testing
  - SQL injection
  - port scanning
  - fuzz testing (fuzz inputs, test input before reaching backend, useful e.g. buffer overflow detection)
- pentesting


## Performance Testing

Concerned about measuring how a system handles different rates of inputs

- Metrics
  - throughput : rate of processed transactions / delta
  - demand : max rate concurrently
  - response : max length taken to respond


- Tests
  - Limit : assessing that the system behaves normally within a required limit
  - Stress : what happens if limit is breached

# Scalling Effects in System Testing

- In system testing we can't use mocks, hence as the number of components increases the number of test cases increases exponentially because the possible number of paths through a program increase expo

![](@attachment/Clipboard_2021-01-22-20-14-23.png)


Scale affects many different characteristics of a system, possibly having different effects on their testing, e.g. :

- number of lines of code
- modules
- platforms
- variation in inputs
- variation in users and their geographic location

...

Ultimately this means that performing testing at a large scale can be very expensive. Dev teams need to develop a test suite which prioritises the main features of the system.


## Heterogeneous Systems

- Large scale software are often divided among teams
- Populated by different business units within same organisation, or different organisations
- The greater the variation between teams, the harder it is to develop a consistent testing suite
- Even if a standard is achieved being overly restrictive, and trying to stifle natural variation, will result in decreased productivity


### TEST CASE - The ATLAS Project

Properties:
 - 7 million source lines of code 
 - 10 major sub-projects 
 - multiple platforms, 
 languages, compilers and 
 configurations 
 - 500 developers 
 - 3000 users (scientists and 
 engineers) 
 - 40 countries. 
​	
 




Testing:
- The core engineer team have created a suite of tests which run periodically to provide a health status of the system, instead of running every test at very commit

This is done via labelled tests (see reading)

## Social-Techical/Computer-based Systems 

- Incorporate software, hardware, users and surrounding organisation

- Organisation as a whole must be tested, not just the software itself

PROBLEMS:
- Obtaining realistic test scenarios may not be practical
- Busy users
- Identifying and covering real working practices is difficult
- The organisation may evolve indep of the sytem


### TEST CASE - Accounting System Elections Scotland 2007

- Unrealistic Scenario "Scale" : Dev team tested extensively, including paying users to fill and manually process 10s of 1000s of ballots . System experienced failures, because it needed to be able to process 100s of 1000s, the sytem
- Unrealistic scenario "Ballot Filling" : system did not cover all the ways a ballot could be filled. Discarded many ballots

## System of Systems

- represent the extreme end of the scale for challenges in software testing, because multiple heterogenous systems which cooperate to produce emergence effects (e.g stock exchange, military coordination systems, air trafic control, supply chain)

- the system is not under control of any one actor, hence it cannot be isolated or configured for a test, one of its members may evolve *during* a test and the expected outputs are not easy to define

### TEST CASE - Flash Crash May 2010

## Feedback

Due to the difficulty of runnign acceptance tests, dev teams augmented their apps to gather information from their users:

- automated crash reporting
- integrated defect reporting
- beta testing : release new features for an existing system to a subset of the users
- A/B testing : different candidates for a new feature

This approach turns users into testers, which can be an option if the system is mature with a large user base, but not ideal for newer systems, preventing takeup.
