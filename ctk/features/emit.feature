Feature: Emit Task
  As an implementer of the workflow DSL
  I want to ensure that emit tasks can be executed within the workflow
  So that my implementation conforms to the expected behavior

  # Tests emit tasks
  Scenario: Emit Task
    Given a workflow with definition:
    """yaml
    document:
      dsl: '1.1.0'
      namespace: default
      name: emit
      version: '1.0.0'
    do:
      - emitEvent:
          emit:
            event:
              with:
                source: https://fake-source.com
                type: com.fake-source.user.greeted.v1
                data:
                  greetings: ${ "Hello \(.user.firstName) \(.user.lastName)!" }
    """
    And given the workflow input is:
    """yaml
    user:
      firstName: John
      lastName: Doe
    """
    When the workflow is executed
    Then the workflow should complete
    And the workflow output should have properties 'id', 'specversion', 'time', 'source', 'type', 'data'
    And the workflow output should have a 'source' property with value:
    """yaml
    https://fake-source.com
    """
    And the workflow output should have a 'type' property with value:
    """yaml
    com.fake-source.user.greeted.v1
    """
    And the workflow output should have a 'data' property with value:
    """yaml
    greetings: Hello John Doe!
    """