Feature: Composite Task
  As an implementer of the workflow DSL
  I want to ensure that composite tasks can be executed within the workflow
  So that my implementation conforms to the expected behavior

  # Tests composite tasks With competing concurrent sub tasks
  Scenario: Fork Task With Competing Concurrent Sub Tasks
    Given a workflow with definition:
    """yaml
    document:
      dsl: '1.1.0'
      namespace: default
      name: fork
      version: '1.0.0'
    do:
      - branchWithCompete:
          fork:
            compete: true
            branches:
              - setRed:
                  set:
                    colors: ${ .colors + ["red"] }
              - setGreen:
                  set:
                    colors: ${ .colors + ["green"] }
              - setBlue:
                  set:
                    colors: ${ .colors + ["blue"] }
    """
    When the workflow is executed
    Then the workflow should complete
    And the workflow output should have a 'colors' property containing 1 items