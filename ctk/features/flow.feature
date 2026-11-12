Feature: Flow Directive
  As an implementer of the workflow DSL
  I want to ensure that tasks are executed in the correct order
  So that my implementation conforms to the expected behavior

  Scenario: Implicit Sequence Flow
    Given a workflow with definition:
    """yaml
    document:
      dsl: '1.1.0'
      namespace: default
      name: implicit-sequence
      version: '1.0.0'
    do:
      - setRed:
          set:
            colors: '${ .colors + [ "red" ] }'
      - setGreen:
          set:
            colors: '${ .colors + [ "green" ] }'
      - setBlue:
          set:
            colors: '${ .colors + [ "blue" ] }'
    """
    When the workflow is executed
    Then the workflow should complete with output:
    """yaml
    colors: [ red, green, blue ]
    """
    And setRed should run first
    And setGreen should run after setRed
    And setBlue should run after setGreen

  Scenario: Explicit Sequence Flow
    Given a workflow with definition:
    """yaml
    document:
      dsl: '1.1.0'
      namespace: default
      name: explicit-sequence
      version: '1.0.0'
    do:
      - setRed:
          set:
            colors: '${ .colors + [ "red" ] }'
          then: setGreen
      - setBlue:
          set:
            colors: '${ .colors + [ "blue" ] }'
          then: end
      - setGreen:
          set:
            colors: '${ .colors + [ "green" ] }'
          then: setBlue
    """
    When the workflow is executed
    Then the workflow should complete with output:
    """yaml
    colors: [ red, green, blue ]
    """
    And setRed should run first
    And setGreen should run after setRed
    And setBlue should run after setGreen