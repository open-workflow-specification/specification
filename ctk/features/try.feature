Feature: Try Task
  As an implementer of the workflow DSL
  I want to ensure that try tasks can be executed within the workflow
  So that my implementation conforms to the expected behavior

  # Tests that try tasks complete when catching errors, and execute the defined handler task, if any
  # Tests simple uri interpolation
  # Tests custom error variable name
  # Tests error instance path
  Scenario: Try Handle Caught Error
    Given a workflow with definition:
    """yaml
    document:
      dsl: '1.0.3'
      namespace: default
      name: try-catch-404
      version: '1.0.0'
    do:
      - tryGetPet:
          try:
            - getPet:
                call: http
                with:
                  method: get
                  endpoint:
                    uri: https://petstore.swagger.io/v2/pet/getPetByName/{petName}
          catch:
            errors:
              with:
                type: https://open-workflow-specification.org/dsl/errors/types/communication
                status: 404
            as: err
            do:
              - setError:
                  set:
                    error: ${ $err }
    """
    And given the workflow input is:
    """yaml
    petName: Milou
    """
    When the workflow is executed
    Then the workflow should complete
    And the workflow output should have properties 'error', 'error.type', 'error.status', 'error.title'
    And the workflow output should have a 'error.instance' property with value:
    """yaml
    /do/0/tryGetPet/try/0/getPet
    """

  # Tests that try tasks fault when an uncaught error is raised
  # Tests simple uri interpolation
  # Tests custom error variable name
  # Tests error instance path
  Scenario: Try Raise Uncaught Error
    Given a workflow with definition:
    """yaml
    document:
      dsl: '1.0.3'
      namespace: default
      name: try-catch-503
      version: '1.0.0'
    do:
      - tryGetPet:
          try:
            - getPet:
                call: http
                with:
                  method: get
                  endpoint:
                    uri: https://petstore.swagger.io/v2/pet/getPetByName/{petName}
          catch:
            errors:
              with:
                type: https://open-workflow-specification.org/dsl/errors/types/communication
                status: 503
            as: err
            do:
              - setError:
                  set:
                    error: ${ $err }
    """
    And given the workflow input is:
    """yaml
    petName: Milou
    """
    When the workflow is executed
    Then the workflow should fault