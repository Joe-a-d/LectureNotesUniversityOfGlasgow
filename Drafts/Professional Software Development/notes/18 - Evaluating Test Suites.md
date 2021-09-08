# 18 - Evaluating Test Suites

- writing and maintaining tests have a cost that should be considered in light of ROI. 
- useful metrics of test suite to consider
  - effectiveness : ability to prevent introduction of defects
  - efficiency : cost of maintenance
- in practice there is a trade off between
  - maximising the test coverage of a system (increase number of defects discovered)
  - minimising the cost of conducting testing per defect discovered

![](@attachment/Clipboard_2021-07-10-17-09-18.png)

## Useful Metrics

- post release reported defects : maximise
- LOC
  - efficiency : minimise (loc /  #defects found)
  - effectiveness : maximise loc reached
- execution time : minimise
- failed tests per defect 
  - a lot of tests failing on a single defect might indicate redundancy
- Test suite LOC : larger test suite codebase -> less efficient

![](@attachment/Clipboard_2021-07-10-17-11-34.png)

### Run Time

- single class tests should run in a matter of seconds so that
  - devs incorporate running tests into their workflow
  - check and fix before committing
- profiler tools can be used to evaluate the run time and identify bottle necks
  - e.g. common problem is including I/O which should be replaced by test doubles (mocks, fakes)

## Coverage

- measures both efficiency and effectiveness

$$
\begin{array}{c}\text { effectiveness }=\text { unique LoC executed / total LoC } \\ \text { efficiency = total LoC / (total LoC + LoC executed count) }\end{array}
$$

- different levels of granularity (increase as we go down the list)
  - LOC
  - statements executes
  - expressions executed

- note that since it requires the code to be executed we talk about *dynamic code analysis*

### Refining LOC

- When using LOC level of granularity , it's safe to ignore
  - declarations such as imports
  - parentheses
  - white space
  - documentation
  - "uninteresting" methods (accessors, mutators)
    - getters and setters

### Limits

- it doesnt measure anything to do with defects, hence can be misleading
  - assumes uniform distribution of defects
  - assumes that executing a line of code is enough to reveal defects
    - reliant on the quality of the test suite
- if test code coverage is favoured over defect coverage there is a perverted incentive for developers to increase lines of code reach instead of increasing the number of cases being tested (assertions)

# Mutation Testing

- tests the likelihood that a change to a software system will be detected by one or more failing test cases
  - more sophisticated measure of effectiveness
- it works by representing the introduction of defects as combinations of small-scale code mutations of the target system's code
- the ability of the test suite to detect this manufactured defects is then taken as an estimate for the true effectiveness

## Mutation Operators

- a mutation operation is a small, legal alteration to a program's logic that could potentially have an effect in its behaviour
  - their inherent properties allow them to be introduced automatically, hence giving devs the ability to generate a large number of mutant programs
  - resulting programs (mutants) must be viable, e.g. no syntax errors can be introduced

### Types

Replacing:
- conditional operators with their boundary counterparts
- infix mathematical operators with other operations
- member field values with default or other values
- variable values with default values
- constructor calls with null assignments
- returned values with default values
- method call results with default values.

#### Example

```java
// original
this.term = 0;

while (amount > 0.0){
  this.term ++;
  amount = amount * (1 + monthlyInterest);
  amount = amount - monthlyPayment;
}
finalPayment = amount + monthlyPayment;

// replacing incrementor ++ with decrementor --

this.term = 0;

while (amount > 0.0){
  this.term --;
  amount = amount * (1 + monthlyInterest);
  amount = amount - monthlyPayment;
}
finalPayment = amount + monthlyPayment;
```
## Process

- Baseline version of the system and test suite
  - Baseline should be "green" , i.e. system passes all the tests
- Random combinations of mutations are applied to the codebase
- Test suite runs on the mutants, categorising them in 1 of 3 ways
  - killed : detected
  - survivor : undetected , which may indicate that no test covers it or that it is functionally equivalent to the original baseline
  - undetermined : programs that do no halt , runtime error or because the mutant breaks the code (e.g. infinite loop)

![](@attachment/Clipboard_2021-07-10-17-39-51.png)

## Metrics

$$
\begin{array}{l}\text { mutant survival rate = #survivors / all mutants } \\ \text { efficiency = killed mutants / failed tests }\end{array}
$$

- ideally 1-1 relationship between mutants and failed tests
  - single mutant -> several failures -> possible redundancy
- redundant tests that never fail may not be detected, to overcome this shortcoming we can calculate the *minimal test case set* - the smallest set of test cases that can cover all defects

## Evaluation

- given high coverage one might want to experiment with removing some tests to see if efficiency can be improved. The results are shown below
  - removing half of the tests has little effect on the number of mutants killed, hence revealing that the tests removed contribute little in terms of effectiveness
  - note however that removing a third test cuts the mutant detection rate by 1/2, hence the most effective tests should be retained and their effectiveness evaluated as the system evolves

![](@attachment/Clipboard_2021-07-10-18-01-08.png)

## Configuration Space and Optimisation

- the metrics produced by mutation testing are dependent on a range of configuration options
  - choice of operations
    - significant impact on the type of defects simulated
  - number and combination of mutations
    - The more mutants created, the richer the set of defects to be evaluated, but also the greater the risk of redundant mutants
  - timeout period for completing a test case
  - scope of test suite for each 
  
## Comparing Results across Applications

- not always a good idea
  - Two different configurations for different projects will have different affects on the performance of the underlying test suite
  - Two projects may have very different characteristics, that are better tested using very different configurations

## Limitations

- The effectiveness of the mutation testing process is dependent on careful configuration of the process.
- Mutation operations (or their random combination) may not be representative of the types of defect that are introduced into a project.
  - e.g. precision defects may not show up by mathematical mutations
- Mutation testing takes a long time to run, because the entire test suite must be executed on each mutant