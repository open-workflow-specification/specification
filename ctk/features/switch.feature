Feature: Switch Task
  As an implementer of the workflow DSL
  I want to ensure that the Switch task behaves correctly
  So that my implementation conforms to the expected behavior

  Scenario: Switch task with matching case
    Given a workflow with definition:
    """yaml
    document:
      dsl: '1.1.0'
      namespace: default
      name: switch-match
      version: '1.0.0'
    do:
      - switchColor:
          switch:
            - red:
                when: '.color == "red"'
                then: setRed
            - green:
                when: '.color == "green"'
                then: setGreen
            - blue:
                when: '.color == "blue"'
                then: setBlue
      - setRed:
          set:
            colors: '${ .colors + [ "red" ] }'
          then: end
      - setGreen:
          set:
            colors: '${ .colors + [ "green" ] }'
          then: end
      - setBlue:
          set:
            colors: '${ .colors + [ "blue" ] }'
          then: end
    """
    And given the workflow input is:
    """yaml
    color: red
    """
    When the workflow is executed
    Then the workflow should complete with output:
    """yaml
    colors: [ red ]
    """
    And switchColor should run first
    And setRed should run last

  Scenario: Switch task with implicit default case
    Given a workflow with definition:
    """yaml
    document:
      dsl: '1.1.0'
      namespace: default
      name: switch-default-implicit
      version: '1.0.0'
    do:
      - switchColor:
          switch:
            - red:
                when: '.color == "red"'
                then: setRed
            - green:
                when: '.color == "green"'
                then: setGreen
            - blue:
                when: '.color == "blue"'
                then: setBlue
          then: end
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
    And given the workflow input is:
    """yaml
    color: yellow
    """
    When the workflow is executed
    Then the workflow should complete with output:
    """yaml
    color: yellow
    """
    And switchColor should run first
    And switchColor should run last
    
  Scenario: Switch task with explicit default case
    Given a workflow with definition:
    """yaml
    document:
      dsl: '1.1.0'
      namespace: default
      name: switch-default-implicit
      version: '1.0.0'
    do:
      - switchColor:
          switch:
            - red:
                when: '.color == "red"'
                then: setRed
            - green:
                when: '.color == "green"'
                then: setGreen
            - blue:
                when: '.color == "blue"'
                then: setBlue
            - anyOtherColor:
                then: setCustomColor
      - setRed:
          set:
            colors: '${ .colors + [ "red" ] }'
      - setGreen:
          set:
            colors: '${ .colors + [ "green" ] }'
      - setBlue:
          set:
            colors: '${ .colors + [ "blue" ] }'
      - setCustomColor:
          set:
            colors: '${ .colors + [ $input.color ] }'
    """
    And given the workflow input is:
    """yaml
    color: yellow
    """
    When the workflow is executed
    Then the workflow should complete with output:
    """yaml
    colors: [ yellow ]
    """
    And switchColor should run first
    And setCustomColor should run last
   