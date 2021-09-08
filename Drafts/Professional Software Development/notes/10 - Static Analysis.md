# 10 - Static Analysis

Static analysis tools are an effective means of automatically detecting bugs and poor style that can be eliminated prior to code review as part of a continuous integration pipeline.

# Static Vs Dynamic

- static
  - applied on artifacts at rest, i.e. before execution
  - source, compiled code
- dynamic
  - applied during execution
  - dependent on the spec of appropriate test scenarios (e.g. results are displayed within 5sec of the user clicking the button)

# Motivation

- detect a wide variety of defects prior to submission to review
- can be checked in the CI pipeline, preventing breaking/sub-optimal changes
- assist reviewers in assessing proposed changes
  - focus on measurements performing poorly, suggest improvements to tackle them

# Self documenting code , Style Standards

- write code in a way that it does not require supplementary explanation in the form of comments in order to be understood
- most languages nowadays will have official style standards (e.g. PEP8). Following them usually means that other users familiar with that language will more readily understand your code
  - vendor driven 
  - community driven
  - linters can be used to help with compliance
- some teams adopt internal standards, these are often more important, since it guarantees that a specific codebase is consistent

# Bug Detection

- identify potential bugs from poor usage patterns
  - property methods that can return null
  - access of null object properties
  - inconsistent return statements in a method or function
  - overloaded method names
  - redefined or re-assigned variables or parameters

#### Example - Vulnerability Analysis

![](@attachment/Clipboard_2021-07-09-22-00-45.png)

# Measuring Designs

- more details in OOSE2

## Cyclomatic Complexity

- informs readability
- complexity = edges - nodes + terminals * 2

```Java
public static void printEvens(){
  for (int i = 0; i < 100; i++)
    if (i % 2 == 0)
      out.println(i);
}
```

![](@attachment/Clipboard_2021-07-09-22-03-28.png)

- c = 7 - 6 + 1 * 2 = 3

## Nested Scope Depth

- counts the total depth of the blocks
- nested code can be difficult to maintain, as variables defined higher up in the scope can be altered further down the scope
  - cyclomatic omplexity does not account for this deep nesting

## Coupling

- rate of coupling between modules
- raw measures (what)
  - method calls and var accesses
  - import statements
  - type usages
  - inheritance relations
- scope (where)
  - method
  - class
  - module
  - package
  - app

### Fan in Vs Fan out 

- use the above metrics to calculate more sophisticated metrics
- in : describes the number of inbound references to a class from other classes
  - useful for more precisely id the number of classes that might have to change if the referenced classes change
- out : converse of in
  - useful for id how often a class might need to change given its dependence on other classes

### Inheritance Depth and Width

- used to understand design considerations within a inheritance hierarchy
- deep
  - may indicate over-abstraction
  - harder to change top-level classes
- wide
  - many children may indicate the potential for immediate abstractions
  - reduces duplicate code