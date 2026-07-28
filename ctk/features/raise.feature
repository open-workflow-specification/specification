Feature: Raise Task
  As an implementer of the workflow DSL
  I want to ensure that the Raise task behaves correctly
  So that my implementation conforms to the expected behavior

  Scenario: Raise task with inline error
    Given a workflow with definition:
    """yaml
    document:
      dsl: '1.0.3'
      namespace: default
      name: raise-custom-error
      version: '1.0.0'
    do:
      - raiseError:
          raise:
            error:
              status: 400
              type: https://open-workflow-specification.org/errors/types/compliance
              title: Compliance Error
    """
    When the workflow is executed
    Then the workflow should fault with error:
    """yaml
    status: 400
    type: https://open-workflow-specification.org/errors/types/compliance
    title: Compliance Error
    instance: /do/0/raiseError
    """
