# 6 - Software Process Improvement

- there are many practices in a SE project
  - may be impractical to apply all at the start
  - practices may evolve with time
- Hence
  - software process improvement practices provide a *structured* means for a team to reflect on their process and id opportunities for improvement

# Frameworks

- ISO 9001
- Six Sigma
- CMMI - capability maturity model

- common feature : they pre-define the characteristics of a functioning software process, rather than permitting measuring and adjustment

# Principles Agile Process Improvement

- Measurement is domain specific
  - measurements are not transferable across projects
- Improvement is an on-going activity
- Requires whole team participation
  - maximised data gathering
  - buy-in , feel like they have a stake in the project
- Best effort assumption
  - assume that all members are working as hard as they can. working harder is not a solution
  - blaming is counterproductive
- Find root causes, not symptoms

# Process

- Gather data about the process from a variety of sources (e.g. team members, automated tools)
- Analyse the data to evaluate performance and identify root causes
- Identify possible actions to take
- Prioritise and implement actions

# Retrospective

- End of sprint
- Whole team with scrum master as facilitator
- Varying time (min 30min , max 1/2 day)
- Artifacts are better for objective evidence of problems
  - these however need to be interpreted carefully
- Team members self reporting are other source of data, but far more subjective

## Data from Team Members

- Gathering, general method
  - populate a template board independently with what they see as issues
    - "stop, start, continue"
      - "what did not work, and we should stop doing"
      - "what should we start doing, that we are not doing yet"
      - "what worked, that we should continue doing"
    - "sailboat"
    - etc.
  - group together similar items
  - team votes on priority issues for discussion
  - root causes are revealed
  - actions for improvement are selected

## Root Cause - 5 Whys

- method to try and get to a root cause of an issue
- 5 is just a heuristic
- the key aspect is starting from an issue asking "Why" as many times are needed to try to get to the root cause

```
The first release was delivered late.
Why?
Integration took longer than expected.
Why?
A number of incompatabilities emerged late in the sprint.
Why?
Integration was performed at the end of the sprint.
-> We should perform integration throughout the sprint.
```

# Monitoring and Measuring

- Create tickets as appropriates for next milestone
- Ensure actions are assigned
- Include previous decisions in future retrospectives
- Review the process

# Truly Contiuous Process Improvement

- Retrospectives only happen at the end of the sprint, what if a problem is identified within a sprint?
- Some teams diagnose and apply solutions to their process as soon as they are identified
  - quick and effective
  - BUT
    - may disrupte the overall software process, slowing down progress
    - not everyone may be invested in diagnosing problems
  - COMPROMISE
    - diagnose and recommend solution in real time but discuss in the retrospective