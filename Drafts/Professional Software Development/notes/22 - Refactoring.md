# 22 - Refactoring

Refactoring is a key practice that should occur alongside other software activities. Refactoring is a formalised form of code cleanup, in which changes are made according to a well specified process and with respect to a pre-defined plan. Refactoring opportunities are detected through the occurrence of "bad smells" in code. Each bad smell can be remedied through the application of one or more refactorings. Applying a refactoring may lead to further opportunities to refactor


Refactoring
: a change made to the internal structure of software to make it easier to understand and cheaper to modify without changing its observable behaviour

## Process

![](@attachment/Clipboard_2021-07-14-11-14-14.png)

- ongoing
- well defined
- aims to reduce coupling and increase cohesion

1. identify opportunities
  - *"bad smells"*
1. create tests for the affected classes (if they don't exist)
  - important since it will show that refactored code does not affect the functional behaviour of the code
1. plan refactoring
1. apply plan
  - often IDEs will have tools which can automate this process
1. Run tests

## When

- implementing new functionality
- correcting a defect
- doing a code review
- when trying to grok how an artefact works

## Bad Smells (Fowler)

- [Fowler](http://www.laputan.org/pub/patterns/fowler/smells.pdf)

- **complex structures**
  - long method
    - longer sequences of instructions are harder to understand because all details are presented at once
  - large class
    - too many responsibilities
    - possible duplication of code
- **making changes**
  - divergent change
    - class has too many responsibilities
  - shotgun surgery
    - divergent change reverse
    - single change in environment requires changes in several different classes
  - parallel inheritance 
  hierarchies
    - dependencies between 2 independent hierarchies
    - increases coupling and maintenance costs
    - specialised form of shotgun surgery
- **design uncertainty**
  - lazy class
    - insufficient independent responsibilities, expensive maintenance
  - speculative generality
    - avoidance of design decisions in order to maintain generality
    - *"inner platform"* anti pattern - it is so general that it becomes a platform that needs to be configured on top of an existing platform
  - incomplete library class
- **vars and params**
  - long param list
    - imposes *stamp coupling* because if the param list changes each call must also be changed
    - also indicates that a method is used in several ways depending on how it is called
  - feature envy
    - it obtains most of its data from another class, indicating that it is in the wrong class
  - data clumps
    - same, independently sourced data is used together in different locations (e.g. duplicate parms list, duplicate blocks of query method calls)
  - primitive obsession
    - preference for using primitive data types for representing more complex values with additional semantics
    - requires extra maintenance to maintain the semantics, since it does not exist in the primitive types themselves
  - temporary field
    - fields used as vars but are not always needed
- **control structures and polymorphism**
  - switch statements
    - not exploiting  OO polymorphism
    - increases maintenance costs
  - refused bequest
    - subclass inherits from superclass unnecessary methods
    - high coupling
  - alternative classes with different interfaces
    - prevents use of OO polymorphism
- **cloning**
  - duplicate code
- **delegation**
  - message chains
    - one object accesses a data item through a series of intermediary objects
    - high coupling
  - middle man
    - object acts as an information broker to another object
    - OK if the inteded use was for the object to act as a proxy
  - inappropriate intimacy
    - *"object orgy"*
    - all objects freely interact
  - data class
    - class lacks behavioural responsibilities, not just data in their state

## Refactoring Strategies

- [Refactoring Guru](https://refactoring.guru) 

/
/

- **fixing methods**
  - extract method to inline method or vice-versa
  - replace method with method object
- **moving functionality**
  - move method, field
  - extract class or inline class
- **organising data**
  - encapsulate field
  - replace magic numbers with symbolic constants
  - replace data value with object
- **simplifying method calls**
  - parameterise method or remove parameter
  - use param object
- **simplifying conditions**
  - decompose conditional
  - consolidate duplicate conditional fragments
  - replace conditional with polymorphism
- **reorganising classes**
  - pull up or push down method
    - move methods to parent classes if repetead in children
    - move methods to only children using it if only a few using it
  - pull up or push down field
  - extract superclass
  - extract subclass
  - collpase hierarchy

  ### Smells-Refactoring Mapping

  ![](@attachment/Clipboard_2021-07-14-12-54-11.png)
  ![](@attachment/Clipboard_2021-07-14-12-54-19.png)
  ![](@attachment/Clipboard_2021-07-14-12-54-24.png)

  ### Example

  See slides

  ## Limitations

  - changes can effect
    - non-functional properties
      - may be either beneficial or detrimental
      - may reduce memory usage while increasing response time
        - reduce cloning leads to increase number of method calls
    - API
      - problematic if the API is public since it might break users' apps 
      - two versions might need maintenace during transition
  