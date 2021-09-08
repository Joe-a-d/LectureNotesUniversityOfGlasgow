# 17 - Behaviour Driven Development

BDD provides a means, through executable specifications, of ensuring
traceability between user facing requirements and implementations

# Terminology

Test case
: the description of a set of actions to be performed on software and an expected outcome

Test
: the execution of a test case, producing an outcome

Testing
: the practice of creating, maintaining, executing and evaluating test cases

# Motivation

- Detection of defects
- Support the design an implementation of a module
- Prevent the introduction of defects
- Document the behaviour of a system
- Demonstrate that a system meets its specification

- nowadays the emphasis has shifted away from iding and removing defects towards the prevention of their introduction as part of a continuous management system

# Scales of Testing

- Unit
  - focus on checking the behaviour of a single module , e.g. class
  - execution needs to be very fast, often rely on mocks avoiding I/O
- Acceptance
  - performed on a fully integrated system
  - costly , because they necessarily rely on external resources
  - often triggered manually, because more expensive to automate
  - non-functional properties are treated as acceptance test cases
    - do not rely on mocks
- Integration
  - sit between acceptance and unit, being performed on integrations of sub-sets of the system's components  
  - mocks can still be used

# BDD

- creation and maintenance of a requirements spec in a structured natural language - Gherkin - from which test cases can be derived automatically and executed against a target implementation
- specification by example
  - when user stories express requirements, and scenarios are derived from them
  - user stories : high level of feature
  - scenarios : example of a use case of the feature
- language concepts should refer to the problem domain rather than the technical domain
  - e.g. avoid refer to programming language concepts (e.g. operators, exceptions) in the user stories and scenarios
- BDD provides technical infrastructure for explicitly linking these artefacts to the implementation. 
  - allows the presence of features described in a language understood by users (Gherkin) to be demonstrated in a corresponding implementation
  - **Hence** , BDD is generally used for writing system or acceptance test cases for the purpose of supporting the design of a system with users, demonstrating the implementation meets the specification and documenting the behaviour

## Life-cyle for Feature Development

1. Features -> Stories
1. -> Scenarios
1. -> Steps
1. -> Step functions : translation into the target app language
1. -> Drive the design of the API
1. -> Implementation

![](@attachment/Clipboard_2021-07-10-00-05-05.png)

### Step Types

- `Given` : arranging the objects that will participate in the tests (setup fixtures)
- `When` : perform some actions upon those objects (execute)
- `Then`: assert some properties hold after the actions are applied (assert)
- `And` : special type which acts as a synonym for whichever step preceded it (if used first, it collapses to "when")

- Can also use "Backgrounds" to reduce duplication and group steps to be used by every scenario (similar to python's setUp class)

- Mirror the "Triple A" pattern for unit test cases

### From Spec to Execution

- Each scenario can be mapped into a test case within a test framework (e.g. python's unittest)

```python
from unittest import TestCase
from banking import BankAccount
  class BankTestCase(TestCase):
    def test_deposit_an_amount_into_the_account(self):
    # Given a bank account
    self.bank_account = BankAccount()
    # When I deposit 100 GBP into the bank account
    self.bank_account.deposit(100)
    # Then the bank account balance should be 100 GBP.
    assert self.bank_account.balance == 100
```

## Frameworks

- setting up test cases involve a lot of repetition , to avoid this several language specific frameworks exist. e.g.:
  - Jbehave, Behave, Cucumber ...
- their main function is linking individual Gherkin steps to functions or method - *step definition functions* - in the app's language
  - no longer required to maintain both the test cases and the gherkin file. Instead, devs only have to ensure that there exists one step def func for each unique step in the gherkin file
  - these can be parameterised to take different parameters in different runs
  - *example tables* can be combined in scenarios so that different parameters lead to different actions
      - ![](@attachment/Clipboard_2021-07-10-00-33-48.png)

![](@attachment/Clipboard_2021-07-10-00-23-45.png)

#### Example - Behave 

```python
# step definition functions
from banking import BankAccount, Transaction

@given('a bank account for "Alice“’)
def step_impl(context):
  context.bank_accounts['Alice'] = BankAccount('Alice’)

@when(u'I deposit 100 GBP into the bank account for "Alice“’)
def step_impl(context):
  context.bank_accounts['Alice'].deposit(100)

@then('the bank account for "Alice" balance should be 100 GBP’)
def step_impl(context):
  assert 100 == context.bank_accounts['Alice'].balance
```

## Where to implement step functions?

- on the API (as exemplified above)
- at the system interface, e.g. user interface of REST API
  - in principle more desirable
  - more costly
  - harder to implement
  - small UI changes outside of the control of the project lead to costly updates
  - tools such as Selenium try to mititgate this


## Good Practices

- short scenarios
  - abstracte if needed
- short steps
- AAA convention
- features in user domain language
- use frameworks
- develop features and implementation gradually
- work with the customer to validate features

## Limitations

- spec by example meand lots of examples required
  - hard to maintain
- brevity/abstraction difficulty 
- need to maintain step definitios as features or API changes (redundancy)
- Hard coding of dependencies in given step definitions
- Only one level of abstraction possible in Gherkin, so you get lots of duplicate sequences of steps
- Gherkin steps are implicitly sequential, so all combinations of orders need to be expressed.