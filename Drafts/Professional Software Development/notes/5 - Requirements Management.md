# 5 - Requirements Management

- requirements specify what a system should do
  - actions an actor can perform (functional)
  - properties of the system an actor can observe (non-functional)
- requirements vs design
  - what vs how
  - in practice the pre-existing frameworks and libraries may constrain the design and requirements themselves, hence it is not always easy to separate design from requirements

# Managing requirements

- focus of on-going discussion with the customer
- drives acceptance testing

- many different specification notation
  - formal : better for driving acceptance testing, but harder to negotiate with customer
  - UML
  - pseudo code
  - natural language : richer, easier to use in discussion with laymen, but less precise
  - etc.

# User Stories

- In agile, **user stories** are prefered

## Actors

- describe the categories of users
- include specific motivation
  - goals
  - frustrations
- help to identify the system's stakeholder that the requirement might need to be negotiated with
- also useful to document requirements for non-human actors

### Example

- E the Estate Agent
- Goals
  - sell more houses
- Frustration
  - customers can't self-register
  - unable to answer buyers' questions
  - unable to schedule viewings

## User Stories/Features

- written from the perspective of a actor
- rationale should not be circular
- form the **basis for negotiation**
- usually stored within text files in the project VC system
  - easy maintenance
  - integrates well with BDD
- use the following template
```
As an [actor]
I want to [action]
So that [rationale]
```
```
As a first time house buyer
I want to enquire about
available properties that
match my preferences So
that I can find somewhere
to live.
```

### Requirements Scope

- *In theory* every action should be a user story, but:
  - requires the scope to be unbounded
  - many user stories would be duplicated across multiple systems
  - wasted effort on acceptance testing of underlying dependencies
- Instead
  - focus on the business logic
  - treat framework features as assumptions about user roles

![](@attachment/Clipboard_2021-07-09-18-23-46.png)

## Refinements 

- as the negotiations evolve, we should refine our user stories further

### Adding more detail

- in the example above, we could specify what is meant by preferences
  - e.g. budget, location, type

### Tasks

- the user story may then be partitioned into tasks/issues
- this level of granularity makes it easy to estimate cost of a task and for devs to know what needs to be done

### Prioritisation - MoSCoW

- a technique used to estimate what is essential to a particular project so that tasks can be prioritised accordingly

- **M**ust have : critical set of features
- **S**hould have : not having them would hinder usability
- **C**ould have : stretch goals, niceties
- **w**on't have (this time): speculative features that are not within the current budget

### Estimating Tasks

- difficult , some even arguing that is fruitless
- but
  - sometimes necessary to budgeting and wider planning
  - helps indentify tasks that are poorly understood and force refinement (side benefit)

- **Methods**
  - delphi : consensus amongst experts
    - poker planning, pop with agile
  - market testing 
  - empirical : based on comparison to previous projects
    - COCOMO
  - algorithmic : analyse different features or likely properties and come up with an estimate as a result
    - function point analysis

#### Planning Poker

- aims to generate consensus through discussion
- iterative process involving initial individual guesses followed by discussions and new estimates

![](@attachment/Clipboard_2021-07-09-18-42-35.png)

## Scenarios

- describe workflows
- specify acceptance tests
- folllows an arrange/act/assert flow similar to unit testing

```
Given [a fixture]
And [another fixture]
And [...]
When [an action is performed on a feature]
And [another action is performed on a feature]
And [...] Then [a condition is holds]
And [another condition holds]
And [...]
```

#### Example

Given a mocked database of properties
And a property search API
When a text search is performed for 29 Acacia Road
Then Banana Man’s property is returned

## INVEST - Evaluation

- Independent , not depend on other stories
- Negotiable , identifiable actors to refine/negotiate
- Valuable , clear as to why actor cares about it
- Estimate 
- Small 
- Testable

### Bad Smells

```
As a user
I want to search for properties
So that I can find properties.
```

- circular rationale
- unclear actor

```
As an England cricket team fan
I want to be notified of upcoming matches and be able
to filter these notifications by match type (T20, 50-50,
Test). Once I’ve been notified, I want to be able to
retrieve all the match information, such as who is
batting, what the score is, who is bowling, how many
overs have been bowled and so on. Once I’ve got the
detailed view, I’d also like to be able to find out about
a player’s history, such as their batting statistics.
So that I can keep track of all that is going on with my
favourite team.
```

- too big
- hard to estimate , because underspecified

```
As a driver
I want passengers to wait at an agreed location
So that I can pick them up.
```

- not testable , beyond the scope of the software, i.e. "passengers to wait" is not something one can control
  - instead , "want passengers to be notified of a collection point"