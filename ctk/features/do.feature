Feature: Composite Task
  As an implementer of the workflow DSL
  I want to ensure that composite tasks can be executed within the workflow
  So that my implementation conforms to the expected behavior

  # Tests composite tasks with sequential sub tasks
  Scenario: Task With Sequential Sub Tasks
    Given a workflow with definition:
    """yaml
    document:
      dsl: '1.1.0'
      namespace: default
      name: do
      version: '1.0.0'
    do:
      - compositeExample:
          do:
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
    Then the workflow should complete with output:
    """yaml
    colors: [ red, green, blue ]
    """