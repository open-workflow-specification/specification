Feature: Runtime Expressions
  As an implementer of the workflow DSL
  I want to ensure that jq runtime expressions map their output stream to a single value consistently
  So that my implementation conforms to the expected behavior

  # Tests that a filter emitting a single value returns that value as-is (not wrapped in an array)
  Scenario: Expression emitting a single value is returned as-is
    Given a workflow with definition:
    """yaml
    document:
      dsl: '1.0.3'
      namespace: default
      name: expression-single-value
      version: '1.0.0'
    do:
      - pickFirst:
          set:
            result: ${ .numbers[0] }
    """
    And given the workflow input is:
    """yaml
    numbers: [1, 2, 3]
    """
    When the workflow is executed
    Then the workflow should complete with output:
    """yaml
    result: 1
    """

  # Tests that a filter emitting multiple values collects them into an array, in emission order
  Scenario: Expression emitting multiple values is collected into an array
    Given a workflow with definition:
    """yaml
    document:
      dsl: '1.0.3'
      namespace: default
      name: expression-multiple-values
      version: '1.0.0'
    do:
      - collectAll:
          set:
            result: ${ .numbers[] }
    """
    And given the workflow input is:
    """yaml
    numbers: [1, 2, 3]
    """
    When the workflow is executed
    Then the workflow should complete with output:
    """yaml
    result: [1, 2, 3]
    """

  # Tests that a filter emitting no value (empty) yields JSON null
  Scenario: Expression emitting no value yields null
    Given a workflow with definition:
    """yaml
    document:
      dsl: '1.0.3'
      namespace: default
      name: expression-no-value
      version: '1.0.0'
    do:
      - emitNothing:
          set:
            result: ${ empty }
    """
    And given the workflow input is:
    """yaml
    numbers: [1, 2, 3]
    """
    When the workflow is executed
    Then the workflow should complete with output:
    """yaml
    result: null
    """

  # Tests that a filter emitting JSON null yields JSON null
  Scenario: Expression emitting null yields null
    Given a workflow with definition:
    """yaml
    document:
      dsl: '1.0.3'
      namespace: default
      name: expression-null-value
      version: '1.0.0'
    do:
      - emitNull:
          set:
            result: ${ null }
    """
    And given the workflow input is:
    """yaml
    numbers: [1, 2, 3]
    """
    When the workflow is executed
    Then the workflow should complete with output:
    """yaml
    result: null
    """

  # Tests that an error raised after a value has been emitted still fails the expression,
  # because the complete output stream is always evaluated
  Scenario: Expression raising an error after emitting a value fails evaluation
    Given a workflow with definition:
    """yaml
    document:
      dsl: '1.0.3'
      namespace: default
      name: expression-error-after-value
      version: '1.0.0'
    do:
      - emitThenFail:
          set:
            value: ok
          output:
            as: '1, error("boom")'
    """
    And given the workflow input is:
    """yaml
    numbers: [1, 2, 3]
    """
    When the workflow is executed
    Then the workflow should fault with error:
    """yaml
    type: https://open-workflow-specification.org/spec/1.0.0/errors/expression
    status: 400
    """
