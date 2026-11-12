Feature: For Task
  As an implementer of the workflow DSL
  I want to ensure that for tasks can be executed within the workflow
  So that my implementation conforms to the expected behavior

  # Tests for tasks
  # Tests named iteration item (i.e.: `color`)
  # Tests default iteration index (`index`)
  Scenario: For Task
    Given a workflow with definition:
    """yaml
    document:
      dsl: '1.1.0'
      namespace: default
      name: for
      version: '1.0.0'
    do:
      - loopColors:
          for:
            each: color
            in: '.colors'
          do:
            - markProcessed:
                set:
                  processed: '${ { colors: (.processed.colors + [ $color ]), indexes: (.processed.indexes + [ $index ])} }'
    """
    And given the workflow input is:
    """yaml
    colors: [ red, green, blue ]
    """
    When the workflow is executed
    Then the workflow should complete with output:
    """yaml
    processed:
      colors: [ red, green, blue ]
      indexes: [ 0, 1, 2 ]
    """