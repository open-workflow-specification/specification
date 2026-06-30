# Open Workflow CTK

## Table of Contents

- [Introduction](#introduction)
- [Using the CTK](#using-the-ctk)
  + [Conformance testing](#conformance-testing)
  + [Behavior Driven Development](#behavior-driven-development-bdd)
- [Writing Features and Scenarios](#writing-features-and-scenarios)
    + [Feature File Structure](#feature-file-structure)
    + [Steps](#steps)
      - [Arrange](#arrange)
        + [Define workflow](#define-workflow)
        + [Set workflow input](#set-workflow-input)
      - [Act](#act)
        + [Execute Workflow](#execute-workflow)
      - [Assert](#assert)
        - [Workflow has been cancelled](#workflow-has-been-cancelled)
        - [Workflow ran to completion](#workflow-ran-to-completion)
        - [Workflow has faulted](#workflow-has-faulted)
        - [Workflow output should have properties](#workflow-output-should-have-properties)
        - [Workflow output should have property with value](#workflow-output-should-have-property-with-value)
        - [Workflow output should have property with item count](#workflow-output-should-have-property-with-item-count)
        - [Task ran first](#task-ran-first)
        - [Task ran last](#task-ran-last)
        - [Task ran before](#task-ran-before)
        - [Task ran after](#task-ran-after)
        - [Task has been cancelled](#task-has-been-cancelled)
        - [Task ran to completion](#task-ran-to-completion)
        - [Task has faulted](#task-has-faulted)

## Introduction

The Open Workflow Conformance Test Kit (CTK) is a suite of automated tests designed to ensure that implementations of the Open Workflow Specification conform to the standard. The CTK is composed of multiple Gherkin features, each representing various aspects of the Open Workflow DSL.

Gherkin is a human-readable language used for writing structured tests, which can be understood by both non-technical stakeholders and automated test frameworks. It uses a Given-When-Then syntax to describe the preconditions, actions, and expected outcomes of a test scenario.

## Using the CTK

The Open Workflow CTK serves two primary purposes: conformance testing and Behavior-Driven Development (BDD).

### Conformance Testing

Conformance testing is the process of verifying that an implementation adheres to a given specification. By running the CTK, developers can ensure that their implementations of the Open Workflow DSL behave as expected and meet the defined standards. This is crucial for maintaining interoperability and consistency across different implementations of the Open Workflow Specification.

1. **Clone the Repository**: Start by cloning the Open Workflow CTK repository to your local machine.
   
```sh
git clone https://github.com/serverlessworkflow/specification.git
```

2. **Install Dependencies**: Ensure that you have all the necessary dependencies installed. This typically involves setting up a testing framework that can execute Gherkin tests.

3. **Run the Tests**: Execute the Gherkin features using your preferred test runner. 

4. **Review Results**: After running the tests, review the results to ensure that your implementation passes all the scenarios. Any failures indicate deviations from the Open Workflow Specification.

### Behavior-Driven Development (BDD)

Behavior-Driven Development (BDD) is an agile software development process that encourages collaboration among developers, testers, and business stakeholders. BDD focuses on defining the behavior of a system through examples in a shared language, which in this case is Gherkin.

By using the CTK for BDD, teams can:

**Define Behavior**: Write Gherkin scenarios that describe the expected behavior of the Open Workflow DSL. This helps in clearly specifying requirements and expected outcomes.

**Facilitate Collaboration**: Use the Gherkin scenarios to facilitate discussions and collaboration between technical and non-technical team members. This ensures that everyone has a shared understanding of the system's behavior.

**Automate Testing**: Implement automated tests based on the Gherkin scenarios to continuously verify that the system behaves as expected. This helps in catching regressions early and maintaining high quality.

To use the CTK for BDD:

**Write Scenarios**: Collaborate with stakeholders to write Gherkin scenarios that capture the desired behavior of the workflow.

**Implement Steps**: Implement the steps in the Gherkin scenarios to interact with your workflow system.

**Run and Validate**: Execute the scenarios and validate that the system's behavior matches the expectations defined in the Gherkin scenarios.

## Writing Features and Scenarios

To contribute new features or scenarios to the Open Workflow CTK, follow these guidelines:

### Feature File Structure

Each feature file should be placed in the [`/ctk/features`] directory and follow this structure:

```gherkin
Feature: <Feature Name>
  As a <role>
  I want <feature>
  So that <benefit>

  Scenario: <Scenario Name>
    Given <preconditions>
    When <action>
    Then <expected outcome>
    And <additional outcomes>
```

### Steps

For clarity, we've categorized the Gherkin steps used in the Open Workflow CTK into three main groups: Arrange, Act, and Assert. 

These divisions help clarify the purpose of each step and streamline scenario comprehension. 

The Arrange section sets up the initial state or context, the Act section describes the action, and the Assert section verifies the outcome. This structure enhances readability, aiding stakeholders in understanding the scenario flow and step intent.

#### Arrange

Sets up the initial conditions for the test scenario. 

It includes steps to define the workflow, set the input data for the workflow, and prepare any necessary resources or configurations required for executing the workflow. 

The arrange section of the test ensures that the environment is properly configured before the workflow execution begins.

##### Define workflow

Sets up the scenario by providing the definition of a workflow in either JSON or YAML format. It defines the structure and behavior of the workflow to be tested.

```gherkin
Given a workflow with definition:
"""yaml
<DEFINITION>
"""
```

##### Set workflow input

Specifies the input data for the workflow being tested. It provides the necessary data required for the workflow to execute and produce the expected output.

```gherkin
And given the workflow input is:
"""yaml
<INPUT>
"""
```

#### Act

Represents the action or event that triggers the execution of the workflow.

The act section focuses on performing the specific action that the test scenario aims to verify or validate.

##### Execute workflow

Triggers the execution of the workflow. It initiates the processing of the workflow based on the provided definition and input data.

```gherkin
When the workflow is executed
```

#### Assert

Contains assertions that verify the outcome of the workflow execution. 

It includes steps to check various conditions such as whether the workflow was canceled, completed successfully, or encountered any faults or errors during execution. 

The assert section ensures that the workflow behaves as expected and meets the specified criteria for correctness and reliability.

##### Workflow has been cancelled

Asserts that the workflow was canceled during execution. It checks if the workflow terminated prematurely without completing its intended process.

```gherkin
Then the workflow should cancel
```

##### Workflow ran to completion

Asserts that the workflow execution completed successfully without any errors or faults. It ensures that the workflow ran through its entire process as expected.

```gherkin
Then the workflow should complete
```

Expecting a specific output:

```gherkin
Then the workflow should complete with output:
"""yaml
<EXPECTED_OUTPUT>
"""
```

##### Workflow has faulted

Asserts that the workflow encountered an error during execution. It verifies that the workflow did not complete successfully and identifies the presence of any faults in its execution.

```gherkin
Then the workflow should fault
```

Expecting a specific error:

```gherkin
Then the workflow should fault with error:
"""yaml
<EXPECTED_ERROR>
"""
```

##### Workflow output should have properties

Asserts that the workflow ran to completion and outputs a map that contains the specified single quoted, comma separated, properties.

```gherkin
And the workflow output should have properties '<PROPERTY1_PATH>', '<PROPERTY2_PATH>', '<PROPERTY3_PATH>'
```

##### Workflow output should have property with value

Asserts that the workflow ran to completion and outputs a map that contains the specified single quoted, comma separated, property, which returns the specified value.

```gherkin
And the workflow output should have a '<PROPERTY_PATH>' property with value:
"""yaml
<EXPECTED_VALUE>
"""
```

##### Workflow output should have property with item count

```gherkin
And the workflow output should have a '<PROPERTY_PATH>' property containing <ITEMS_COUNT> items
```


##### Task ran first

Asserts that a specific task within the workflow executed first during workflow execution. It ensures the correct sequence of task execution based on the provided workflow definition.

```gherkin
And <TASK_NAME> should run first
```

##### Task ran last

Asserts that a specific task within the workflow executed last during workflow execution. It ensures the correct sequence of task execution based on the provided workflow definition.

```gherkin
And <TASK_NAME> should run last
```

##### Task ran before

Asserts that `TASK1` executed before `TASK2` during workflow execution. It ensures the correct order of task execution based on the provided workflow definition.

```gherkin
And <TASK1_NAME> should run before <TASK2_NAME>
```

##### Task ran after

Asserts that `TASK2` executed after `TASK1` during workflow execution. It ensures the correct order of task execution based on the provided workflow definition.

```gherkin
And <TASK2_NAME> should run after <TASK1_NAME>
```

##### Task has been cancelled

Asserts that a specific task within the workflow was canceled during execution. It verifies that the task did not complete its execution due to cancellation.

```gherkin
And <TASK_NAME> should cancel
```

##### Task ran to completion

Asserts that a specific task within the workflow completed its execution successfully. It ensures that the task executed without any errors or faults.

```gherkin
And <TASK_NAME> should complete
```

Expecting a specific output:

```gherkin
And <TASK_NAME> should complete with output:
"""yaml
<EXPECTED_OUTPUT>
"""
```

##### Task has faulted

Asserts that a specific task within the workflow encountered an error or fault during execution. It verifies that the task did not complete successfully and identifies any faults in its execution.

```gherkin
And <TASK_NAME> should fault
```

Expecting a specific error:

```gherkin
And <TASK_NAME> should fault with error:
"""yaml
<EXPECTED_ERROR>
"""
```