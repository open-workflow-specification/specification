Feature: Set Task
  As an implementer of the workflow DSL
  I want to ensure that set tasks can be executed within the workflow
  So that my implementation conforms to the expected behavior

  # Tests set tasks
  Scenario: Set Task
    Given a workflow with definition:
    """yaml
    document:
      dsl: '1.1.0'
      namespace: default
      name: set
      version: '1.0.0'
    do:
      - setShape:
          set:
            shape: circle
            size: ${ .configuration.size }
            fill: ${ .configuration.fill }
    """
    And given the workflow input is:
    """yaml
    configuration:
      size:
        width: 6
        height: 6
      fill:
        red: 69
        green: 69
        blue: 69
    """
    When the workflow is executed
    Then the workflow should complete with output:
    """yaml
    shape: circle
    size:
      width: 6
      height: 6
    fill:
      red: 69
      green: 69
      blue: 69
    """