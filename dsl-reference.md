# Open Workflow DSL - Reference

## Table of Contents

- [Abstract](#abstract)
- [Definitions](#definitions)
  + [Workflow](#workflow)
    - [Document](#document)
    - [Use](#use)
    - [Schedule](#schedule)
  + [Task](#task)
    - [Call](#call)
        + [AsyncAPI](#asyncapi-call)
        + [gRPC](#grpc-call)
        + [HTTP](#http-call)
        + [OpenAPI](#openapi-call)
        + [A2A](#a2a-call)
        + [MCP](#mcp-call)
    - [Do](#do)
    - [Emit](#emit)
    - [For](#for)
    - [Fork](#fork)
    - [Listen](#listen)
    - [Raise](#raise)
    - [Run](#run)
        + [Container](#container-process)
        + [Shell](#shell-process)
        + [Script](#script-process)
        + [Workflow](#workflow-process)
    - [Set](#set)
    - [Switch](#switch)
    - [Try](#try)
    - [Wait](#wait)
  + [Flow Directive](#flow-directive)
  + [Lifecycle Events](#lifecycle-events)
    - [Workflow Lifecycle Events](#workflow-lifecycle-events)
      + [Workflow Started](#workflow-started-event)
      + [Workflow Suspended](#workflow-suspended-event)
      + [Workflow Resumed](#workflow-resumed-event)
      + [Workflow Correlation Started](#workflow-correlation-started-event)
      + [Workflow Correlation Completed](#workflow-correlation-completed-event)
      + [Workflow Cancelled](#workflow-cancelled-event)
      + [Workflow Faulted](#workflow-faulted-event)
      + [Workflow Completed](#workflow-completed-event)
      + [Workflow Status Changed](#workflow-status-changed-event)
    - [Task Lifecycle Events](#task-lifecycle-events)
      + [Task Created](#task-created-event)
      + [Task Started](#task-started-event)
      + [Task Suspended](#task-suspended-event)
      + [Task Resumed](#task-resumed-event)
      + [Task Retried](#task-retried-event)
      + [Task Cancelled](#task-cancelled-event)
      + [Task Faulted](#task-faulted-event)
      + [Task Completed](#task-completed-event)
      + [Task Status Changed](#task-status-changed-event)
  + [External Resource](#external-resource)
  + [Authentication](#authentication)
    - [Basic](#basic-authentication)
    - [Bearer](#bearer-authentication)
    - [Digest](#digest-authentication)
    - [OAUTH2](#oauth2-authentication)
    - [OpenIdConnect](#openidconnect-authentication)
  + [Catalog](#catalog)
  + [Extension](#extension)
  + [Error](#error)
    - [Standard Error Types](#standard-error-types)
  + [Event Consumption Strategy](#event-consumption-strategy)
  + [Event Filter](#event-filter)
  + [Event Properties](#event-properties)
  + [Retry](#retry)
  + [Input](#input)
  + [Output](#output)
  + [Export](#export)
  + [Timeout](#timeout)
  + [Duration](#duration)
  + [Endpoint](#endpoint)
  + [HTTP Response](#http-response)
  + [HTTP Request](#http-request)
  + [URI Template](#uri-template)
  + [Container Lifetime](#container-lifetime)
  + [Process Result](#process-result)
  + [AsyncAPI Server](#asyncapi-server)
  + [AsyncAPI Outbound Message](#asyncapi-outbound-message)
  + [AsyncAPI Subscription](#asyncapi-subscription)
  + [Workflow Definition Reference](#workflow-definition-reference)
  + [Subscription Iterator](#subscription-iterator)

## Abstract

This document provides comprehensive definitions and detailed property tables for all the concepts discussed in the Open Workflow DSL. It serves as a reference guide, explaining the structure, components, and configurations available within the DSL. By exploring this document, users will gain a thorough understanding of how to define, configure, and manage workflows, including task definitions, flow directives, and state transitions. This foundational knowledge will enable users to effectively utilize the DSL for orchestrating functions and automating processes.

## Definitions

### Workflow

A [workflow](#workflow) serves as a blueprint outlining the series of [tasks](#task) required to execute a specific business operation. It details the sequence in which [tasks](#task) must be completed, guiding users through the process from start to finish, and helps streamline operations, ensure consistency, and optimize efficiency within an organization.

#### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| document | [`document`](#document) | `yes` | Documents the defined workflow. |
| input | [`input`](#input) | `no` | Configures the workflow's input. |
| use | [`use`](#use) | `no` | Defines the workflow's reusable components, if any. |
| do | [`map[string, task]`](#task) | `yes` | The [task(s)](#task) that must be performed by the [workflow](#workflow). |
| timeout | `string`<br>[`timeout`](#timeout) | `no` | The configuration, if any, of the workflow's timeout.<br>*If a `string`, must be the name of a [timeout](#timeout) defined in the [workflow's reusable components](#use).* |
| output | [`output`](#output) | `no` | Configures the workflow's output. |
| schedule | [`schedule`](#schedule) | `no` | Configures the workflow's schedule, if any. |
| evaluate | [`evaluate`](#evaluate) | `no` | Configures runtime expression evaluation. |

#### Document

Documents the workflow definition.

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| dsl | `string` | `yes` | The version of the DSL used to define the workflow. |
| namespace | `string` | `yes` | The workflow's namespace.<br> |
| name | `string` | `yes` | The workflow's name.<br> |
| version | `string` | `yes` | The workflow's [semantic version](https://semver.org/) |
| title | `string` | `no` | The workflow's title. |
| summary | `string` | `no` | The workflow's Markdown summary. |
| tags | `map[string, string]` | `no` | A key/value mapping of the workflow's tags, if any. |
| metadata | `map` | `no` | Additional information about the workflow. |

#### Use

Defines the workflow's reusable components.

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| authentications | [`map[string, authentication]`](#authentication) | `no` | A name/value mapping of the workflow's reusable authentication policies. |
| catalogs | [`map[string, catalog]`](#catalog) | `no` | A name/value mapping of the workflow's reusable resource catalogs. |
| errors | [`map[string, error]`](#error) | `no` | A name/value mapping of the workflow's reusable errors. | 
| extensions | [`extension[]`](#extension) | `no` | A list of the workflow's reusable extensions. |
| functions | [`map[string, task]`](#task) | `no` | A name/value mapping of the workflow's reusable tasks. |
| retries | [`map[string, retryPolicy]`](#retry) | `no` | A name/value mapping of the workflow's reusable retry policies. |
| secrets | `string[]` | `no` | A list containing the workflow's secrets. |
| timeouts | [`map[string, timeout]`](#timeout) | `no` | A name/value mapping of the workflow's reusable timeouts. |

#### Schedule

Configures the schedule of a workflow.

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| every | [`duration`](#duration) | `no` | Specifies the duration of the interval at which the workflow should be executed. Unlike `after`, this option will run the workflow regardless of whether the previous run is still in progress.<br>*Required when no other property has been set.* |
| cron | `string` | `no` | Specifies the schedule using a CRON expression, e.g., '0 0 * * *' for daily at midnight.<br>*Required when no other property has been set.* |
| after | [`duration`](#duration) | `no` | Specifies a delay duration that the workflow must wait before starting again after it completes. In other words, when this workflow completes, it should run again after the specified amount of time.<br>*Required when no other property has been set.*  |
| on | [`eventConsumptionStrategy`](#event-consumption-strategy) | `no` | Specifies the events that trigger the workflow execution.<br>*Required when no other property has been set.* |

#### Evaluate

Configures a workflow's runtime expression evaluation.

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| language | `string` | `no` | The language used for writing runtime expressions.<br>*Defaults to `jq`.* |
| mode | `string` | `no` | The runtime expression evaluation mode.<br>*Supported values are:*<br>- `strict`: requires all expressions to be enclosed within `${ }` for proper identification and evaluation.<br>- `loose`: evaluates any value provided. If the evaluation fails, it results in a string with the expression as its content.<br>*Defaults to `strict`.*

#### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: order-pet
  version: '0.1.0'
  title: Order Pet - 1.0.0
  summary: >
    # Order Pet - 1.0.0
    ## Table of Contents
    - [Description](#description)
    - [Requirements](#requirements)
    ## Description
    A sample workflow used to process an hypothetic pet order using the [PetStore API](https://petstore.swagger.io/)
    ## Requirements
    ### Secrets
    - my-oauth2-secret
use:
  authentications:
    petStoreOAuth2:
      oauth2: 
        authority: https://petstore.swagger.io/.well-known/openid-configuration
        grant: client_credentials
        client:
          id: workflow-runtime
          secret: "**********"
        scopes: [ api ]
        audiences: [ runtime ]
  extensions:
    - externalLogging:
        extend: all
        before:
          - sendLog:
              call: http
              with:
                method: post
                endpoint: https://fake.log.collector.com
                body:
                  message: ${ "Executing task '\($task.reference)'..." }
        after:
          - sendLog:
              call: http
              with:
                method: post
                endpoint: https://fake.log.collector.com
                body:
                  message: ${ "Executed task '\($task.reference)'..." }
  functions:
    getAvailablePets:
      call: openapi
      with:
        document:
          endpoint: https://petstore.swagger.io/v2/swagger.json
        operationId: findByStatus
        parameters:
          status: available
  secrets:
    - my-oauth2-secret
do:
  - getAvailablePets:
      call: getAvailablePets
      output:
        as: "$input + { availablePets: [.[] | select(.category.name == \"dog\" and (.tags[] | .breed == $input.order.breed))] }"
  - submitMatchesByMail:
      call: http
      with:
        method: post
        endpoint:
          uri: https://fake.smtp.service.com/email/send
          authentication: 
            use: petStoreOAuth2
        body:
          from: noreply@fake.petstore.com
          to: ${ .order.client.email }
          subject: Candidates for Adoption
          body: >
            Hello ${ .order.client.preferredDisplayName }!

            Following your interest to adopt a dog, here is a list of candidates that you might be interested in:

            ${ .pets | map("-\(.name)") | join("\n") }

            Please do not hesistate to contact us at info@fake.petstore.com if your have questions.

            Hope to hear from you soon!

            ----------------------------------------------------------------------------------------------
            DO NOT REPLY
            ----------------------------------------------------------------------------------------------
```

### Task

A task within a [workflow](#workflow) represents a discrete unit of work that contributes to achieving the overall objectives defined by the [workflow](#workflow). 

It encapsulates a specific action or set of actions that need to be executed in a predefined order to advance the workflow towards its completion. 

[Tasks](#task) are designed to be modular and focused, each serving a distinct purpose within the broader context of the [workflow](#workflow). 

By breaking down the [workflow](#workflow) into manageable [tasks](#task), organizations can effectively coordinate and track progress, enabling efficient collaboration and ensuring that work is completed in a structured and organized manner.

The Open Workflow DSL defines a list of [tasks](#task) that **must be** supported by all runtimes:

- [Call](#call), used to call services and/or functions.
- [Do](#do), used to define one or more subtasks to perform in sequence.
- [Fork](#fork), used to define one or more subtasks to perform concurrently.
- [Emit](#emit), used to emit [events](#event-properties).
- [For](#for), used to iterate over a collection of items, and conditionally perform a task for each of them.
- [Listen](#listen), used to listen for an [event](#event-properties) or more.
- [Raise](#raise), used to raise an [error](#error) and potentially fault the [workflow](#workflow).
- [Run](#run), used to run a [container](#container-process), a [script](#script-process) , a [shell](#shell-process) command or even another [workflow](#workflow-process). 
- [Switch](#switch), used to dynamically select and execute one of multiple alternative paths based on specified conditions
- [Set](#set), used to dynamically set the [workflow](#workflow)'s data during the its execution. 
- [Try](#try), used to attempt executing a specified [task](#task), and to handle any resulting [errors](#error) gracefully, allowing the [workflow](#workflow) to continue without interruption.
- [Wait](#wait), used to pause or wait for a specified duration before proceeding to the next task.

#### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| if | `string` | `no` | A [`runtime expression`](dsl.md#runtime-expressions), if any, used to determine whether or not the task should be run.<br>The task is considered skipped if not run, and the *raw* task input becomes the task's output. The expression is evaluated against the *raw* task input before any other expression of the task. |
| input | [`input`](#input) | `no` | An object used to customize the task's input and to document its schema, if any. |
| output | [`output`](#output) | `no` | An object used to customize the task's output and to document its schema, if any. |
| export | [`export`](#export) | `no` | An object used to customize the content of the workflow context. | 
| timeout | `string`<br>[`timeout`](#timeout) | `no` | The configuration of the task's timeout, if any.<br>*If a `string`, must be the name of a [timeout](#timeout) defined in the [workflow's reusable components](#use).* |
| then | [`flowDirective`](#flow-directive) | `no` | The flow directive to execute next.<br>*If not set, defaults to `continue`.* |
| metadata | `map` | `no` | Additional information about the task. |

#### Call

Enables the execution of a specified function within a workflow, allowing seamless integration with custom business logic or external services.

##### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| call | `string` | `yes` | The name of the function to call. | 
| with | `map` | `no` | A name/value mapping of the parameters to call the function with | 

##### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: call-example
  version: '0.1.0'
do:
  - getPet:
      call: http
      with:
        method: get
        endpoint: https://petstore.swagger.io/v2/pet/{petId}
```

Open Workflow Specification defines several default functions that **MUST** be supported by all implementations and runtimes:

- [AsyncAPI](#asyncapi-call)
- [gRPC](#grpc-call)
- [HTTP](#http-call)
- [OpenAPI](#openapi-call)
- [A2A](#a2a-call)

##### AsyncAPI Call

The [AsyncAPI Call](#asyncapi-call) enables workflows to interact with external services described by [AsyncAPI](https://www.asyncapi.com/).

###### Properties

| Name | Type | Required | Description |
|:-----|:----:|:--------:|:------------|
| document | [`externalResource`](#external-resource) | `yes` | The AsyncAPI document that defines the [operation](https://www.asyncapi.com/docs/reference/specification/v3.0.0#operationObject) to call. |
| channel | `string` | `no` | The name of the channel on which to perform the operation. The operation to perform is defined by declaring either `message`, in which case the [channel](https://v2.asyncapi.com/docs/reference/specification/v2.6.0#channelItemObject)'s `publish` operation will be executed, or `subscription`, in which case the [channel](https://v2.asyncapi.com/docs/reference/specification/v2.6.0#channelItemObject)'s `subscribe` operation will be executed.<br>*Used only in case the referenced document uses AsyncAPI `v2.6.0`.*  |
| operation | `string` | `no` | A reference to the AsyncAPI [operation](https://www.asyncapi.com/docs/reference/specification/v3.0.0#operationObject) to call.<br>*Used only in case the referenced document uses AsyncAPI `v3.0.0`.*  |
| server | [`asyncApiServer`](#asyncapi-server) | `no` | An object used to configure to the [server](https://www.asyncapi.com/docs/reference/specification/v3.0.0#serverObject) to call the specified AsyncAPI [operation](https://www.asyncapi.com/docs/reference/specification/v3.0.0#operationObject) on.<br>If not set, default to the first [server](https://www.asyncapi.com/docs/reference/specification/v3.0.0#serverObject) matching the operation's channel. |
| protocol | `string` | `no` | The [protocol](https://www.asyncapi.com/docs/reference/specification/v3.0.0#definitionsProtocol) to use to select the target [server](https://www.asyncapi.com/docs/reference/specification/v3.0.0#serverObject). <br>Ignored if `server` has been set.<br>*Supported values are:  `amqp`, `amqp1`, `anypointmq`, `googlepubsub`, `http`, `ibmmq`, `jms`, `kafka`, `mercure`, `mqtt`, `mqtt5`, `nats`, `pulsar`, `redis`, `sns`, `solace`, `sqs`, `stomp` and `ws`* |
| message  | [`asyncApiMessage`](#asyncapi-outbound-message) | `no` | An object used to configure the message to publish using the target operation.<br>*Required if `subscription` has not been set.* |
| subscription | [`asyncApiSubscription`](#asyncapi-subscription) | `no` | An object used to configure the subscription to messages consumed using the target operation.<br>*Required if `message` has not been set.*  |
| authentication | `string`<br>[`authentication`](#authentication) | `no` | The authentication policy, or the name of the authentication policy, to use when calling the AsyncAPI operation. | 

> [!NOTE]
> Exactly one of `channel` (AsyncAPI `v2.6.0`) or `operation` (AsyncAPI `v3.0.0`) **must** be set, paired with exactly one of `message` or `subscription`.

###### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: asyncapi-example
  version: '0.1.0'
do:
  - publishGreetings:
      call: asyncapi
      with:
        document:
          endpoint: https://fake.com/docs/asyncapi.json
        operation: greet
        server:
          name: greetingsServer
          variables:
            environment:  dev
        message:
          payload:
            greetings: Hello, World!
          headers:
            foo: bar
            bar: baz
  - subscribeToChatInbox:
      call: asyncapi
      with:
        document:
          endpoint: https://fake.com/docs/asyncapi.json
        operation: chat-inbox
        protocol: http
        subscription:
          filter: ${ . == $workflow.input.chat.roomId } 
          consume:
            amount: 5
            for:
              seconds: 10
```

##### gRPC Call

The [gRPC Call](#grpc-call) enables communication with external systems via the gRPC protocol, enabling efficient and reliable communication between distributed components.

###### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| proto | [`externalResource`](#external-resource) | `yes` | The proto resource that describes the GRPC service to call. |
| service.name | `string` | `yes` | The name of the GRPC service to call. |
| service.host | `string` | `yes` | The hostname of the GRPC service to call. |
| service.port | `integer` | `no` | The port number of the GRPC service to call. |
| service.authentication | [`authentication`](#authentication) | `no` | The authentication policy, or the name of the authentication policy, to use when calling the GRPC service. |
| method | `string` | `yes` | The name of the GRPC service method to call. |
| arguments | `map` | `no` | A name/value mapping of the method call's arguments, if any. |

###### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: grpc-example
  version: '0.1.0'
do:
  - greet:
      call: grpc
      with:
        proto: 
          endpoint: file://app/greet.proto
        service:
          name: GreeterApi.Greeter
          host: localhost
          port: 5011
        method: SayHello
        arguments:
          name: ${ .user.preferredDisplayName }
```

##### HTTP Call

The [HTTP Call](#http-call) enables workflows to interact with external services over HTTP.

###### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| method | `string` | `yes` | The HTTP request method. |
| endpoint | `string`\|[`endpoint`](#endpoint) | `yes` | An URI or an object that describes the HTTP endpoint to call. |
| headers | `map` | `no` | A name/value mapping of the HTTP headers to use, if any. |
| body | `any` | `no` | The HTTP request body, if any. |
| query | `map[string, any]` | `no` | A name/value mapping of the query parameters to use, if any. |
| output | `string` | `no` | The http call's output format.<br>*Supported values are:*<br>*- `raw`, which output's the base-64 encoded [http response](#http-response) content, if any.*<br>*- `content`, which outputs the content of [http response](#http-response), possibly deserialized.*<br>*- `response`, which outputs the [http response](#http-response).*<br>*Defaults to `content`.* |
| redirect | `boolean` | `no` | Specifies whether redirection status codes (`300–399`) should be treated as errors.<br>*If set to `false`, runtimes must raise an error for response status codes outside the `200–299` range.*<br>*If set to `true`, they must raise an error for status codes outside the `200–399` range.*<br>*Defaults to `false`.* |

###### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: http-example
  version: '0.1.0'
do:
  - getPet:
      call: http
      with:
        method: get
        endpoint: https://petstore.swagger.io/v2/pet/{petId}
```

##### OpenAPI Call

The [OpenAPI Call](#openapi-call) enables workflows to interact with external services described by [OpenAPI](https://www.openapis.org).

###### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| document | [`externalResource`](#external-resource) | `yes` | The OpenAPI document that defines the operation to call. |
| operationId | `string` | `yes` | The id of the OpenAPI operation to call. |
| parameters | `map` | `no` | A name/value mapping of the parameters, if any, of the OpenAPI operation to call. |
| authentication | [`authentication`](#authentication) | `no` | The authentication policy, or the name of the authentication policy, to use when calling the OpenAPI operation. |
| output | `string` | `no` | The OpenAPI call's output format.<br>*Supported values are:*<br>*- `raw`, which output's the base-64 encoded [http response](#http-response) content, if any.*<br>*- `content`, which outputs the content of [http response](#http-response), possibly deserialized.*<br>*- `response`, which outputs the [http response](#http-response).*<br>*Defaults to `content`.* |
| redirect | `boolean` | `no` | Specifies whether redirection status codes (`300–399`) should be treated as errors.<br>*If set to `false`, runtimes must raise an error for response status codes outside the `200–299` range.*<br>*If set to `true`, they must raise an error for status codes outside the `200–399` range.*<br>*Defaults to `false`.* |

###### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: openapi-example
  version: '0.1.0'
do:
  - findPet:
      call: openapi
      with:
        document: 
          endpoint: https://petstore.swagger.io/v2/swagger.json
        operationId: findPetsByStatus
        parameters:
          status: available
```

##### A2A Call

The [A2A Call](#a2a-call) enables workflows to interact with AI agents described by [A2A](https://a2a-protocol.org/).

###### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| method | `string` | `yes` | The A2A JSON-RPC method to send.<br>*Supported values are:  `message/send`, `message/stream`, `tasks/get`, `tasks/list`, `tasks/cancel`, `tasks/resubscribe`, `tasks/pushNotificationConfig/set`, `tasks/pushNotificationConfig/get`, `tasks/pushNotificationConfig/list`, `tasks/pushNotificationConfig/delete`, and `agent/getAuthenticatedExtendedCard`* |
| agentCard | [`externalResource`](#external-resource) | `no` | The AgentCard resource that describes the agent to call.<br>*Required if `server` has not been set.* |
| server | `string`\|[`endpoint`](#endpoint) | `no` | An URI or an object that describes the A2A server to call.<br>*Required if `agentCard` has not been set, otherwise ignored* |
| parameters | `map` <br> `string` | `no` | The parameters for the A2A RPC method. For the `message/send` and `message/stream` methods, runtimes must default `message.messageId` to a uuid and `message.role` to `user`.<br>*Supports [runtime expressions](dsl.md#runtime-expressions).* |

> [!NOTE]
> The `security` and `securitySchemes` fields of the AgentCard contain authentication requirements and schemes for when communicating with the agent.
>
> On success the output is the JSON-RPC result. On failure runtimes must raise an error with type [https://serverlessworkflow.io/spec/1.0.0/errors/runtime](https://github.com/serverlessworkflow/specification/blob/main/dsl-reference.md#standard-error-types).
>
> For `message/stream` and `tasks/resubscribe` methods the output is a sequentially ordered array of all the result objects.

###### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: a2a-example
  version: '0.1.0'
do:
  - GenerateReport:
      call: a2a
      with:
        method: message/send
        agentCard:
          endpoint: https://example.com/.well-known/agent-card.json
        parameters:
          message:
            parts:
              - kind: text
                text: Generate the Q1 sales report.
```

##### MCP Call

The [MCP Call](#mcp-call) enables workflows to interact with [Model Context Protocol (MCP)](https://modelcontextprotocol.io/) servers.

###### Properties

| Name | Type | Required | Description|
|:-----|:----:|:--------:|:-----------|
| protocolVersion | `string` | `yes` | The version of the MCP protocol to use.<br>*Defaults to `2025-06-18`.* |
| method | `string` | `yes` | The MCP method to call.<br>*Supported values are:*<br>*- `tools/list`: Lists available tools*<br>*- `tools/call`: Calls a specific tool.*<br>*- `prompts/list`: Lists available prompts*<br>*- `prompts/get`: Gets a specific prompt.*<br>*- `resources/list`: Lists available resources.*<br>*- `resources/read`: Reads a specific resource.*<br>*- `resources/templates/list`: Lists available resource templates* |
| parameters | `map`<br>`string` | `no` | The MCP method parameters.<br>*Supports [runtime expressions](dsl.md#runtime-expressions).* |
| timeout | `string`<br>[`duration`](#duration) | `no` | The [`duration`](#duration) after which the MCP call times out. |
| transport | [`transport`](#mcp-transport) | `yes` | The transport to use to perform the MCP call. |
| client | [`client`](#mcp-client) | `no` | Describes the client used to perform the MCP call. |

> [!IMPORTANT]
> Before making any MCP requests, runtimes **must** first send an `initialize` call to establish the connection.
> In most cases, client libraries handle this initialization automatically.

> [!NOTE]
> On success the output of the call is the JSON-RPC result. On failure, runtimes must raise an error with type [https://serverlessworkflow.io/spec/1.0.0/errors/runtime](https://github.com/serverlessworkflow/specification/blob/main/dsl-reference.md#standard-error-types).

###### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: mcp-example
  version: '0.1.0'
do:
  - publishMessageToSlack:
      call: mcp
      with:
        method: tools/call
        parameters:
          name: conversations_add_message
          arguments:
            channel_id: 'C1234567890'
            thread_ts: '1623456789.123456'
            payload: 'Hello, world! :wave:'
            content_type: text/markdown
        transport:
          stdio:
            command: npx
            arguments: [ slack-mcp-server@latest, --transport, stdio ]
            environment:
              SLACK_MCP_XOXP_TOKEN: xoxp-xv6Cv3jKqNW8esm5YnsftKwIzoQHUzAP
```

#### Do

Serves as a fundamental building block within workflows, enabling the sequential execution of multiple subtasks. By defining a series of subtasks to perform in sequence, the Do task facilitates the efficient execution of complex operations, ensuring that each subtask is completed before the next one begins.

##### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| do | [`map[string, task]`](#task) | `no` | The tasks to perform sequentially. |

##### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: do-example
  version: '0.1.0'
use:
  authentications:
    fake-booking-agency-oauth2:
      oauth2:
        authority: https://fake-booking-agency.com
        grant: client_credentials
        client:
          id: serverless-workflow-runtime
          secret: secret0123456789
do:
  - bookHotel:
      call: http
      with:
        method: post
        endpoint: 
          uri: https://fake-booking-agency.com/hotels/book
          authentication: 
            use: fake-booking-agency-oauth2
        body:
          name: Four Seasons
          city: Antwerp
          country: Belgium
  - bookFlight:
      call: http
      with:
        method: post
        endpoint: 
          uri: https://fake-booking-agency.com/flights/book
          authentication: 
            use: fake-booking-agency-oauth2
        body:
          departure:
            date: '01/01/26'
            time: '07:25:00'
            from:
              airport: BRU
              city: Zaventem
              country: Belgium
          arrival:
            date: '01/01/26'
            time: '11:12:00'
            to:
              airport: LIS
              city: Lisbon
              country: Portugal
```

#### Emit

Allows workflows to publish events to event brokers or messaging systems, facilitating communication and coordination between different components and services. With the Emit task, workflows can seamlessly integrate with event-driven architectures, enabling real-time processing, event-driven decision-making, and reactive behavior based on incoming events.

##### Properties

| Name | Type | Required | Description |
|:--|:---:|:---:|:---|
| emit.event | [`eventProperties`](#event-properties) | `yes` | Defines the event to emit. |

##### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: emit-example
  version: '0.1.0'
do:
  - emitEvent:
      emit:
        event:
          with:
            source: https://petstore.com
            type: com.petstore.order.placed.v1
            data:
              client:
                firstName: Cruella
                lastName: de Vil
              items:
                - breed: dalmatian
                  quantity: 101
```

#### For

Allows workflows to iterate over a collection of items, executing a defined set of subtasks for each item in the collection. This task type is instrumental in handling scenarios such as batch processing, data transformation, and repetitive operations across datasets.

##### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| for.each | `string` | `no` | The name of the variable used to store the current item being enumerated.<br>Defaults to `item`. |
| for.in | `string` \| `array<object>` | `yes` | A [runtime expression](dsl.md#runtime-expressions) or an inline array of objects used to get the collection to enumerate. |
| for.at | `string` | `no` | The name of the variable used to store the index of the current item being enumerated.<br>Defaults to `index`. |
| while | `string` | `no` | A [runtime expression](dsl.md#runtime-expressions) that represents the condition, if any, that must be met for the iteration to continue. |
| do | [`map[string, task]`](#task) | `yes` | The [task(s)](#task) to perform for each item in the collection. |

##### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: for-example
  version: '0.1.0'
do:
  - checkup:
      for:
        each: pet
        in: .pets
        at: index
      while: .vet != null
      do:
        - waitForCheckup:
            listen:
              to:
                one:
                  with:
                    type: com.fake.petclinic.pets.checkup.completed.v2
            output:
              as: '.pets + [{ "id": $pet.id }]'        
```

#### Fork

Allows workflows to execute multiple subtasks concurrently, enabling parallel processing and improving the overall efficiency of the workflow. By defining a set of subtasks to perform concurrently, the Fork task facilitates the execution of complex operations in parallel, ensuring that multiple tasks can be executed simultaneously.

##### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| fork.branches | [`map[string, task]`](#task) | `no` | The tasks to perform concurrently. | 
| fork.compete | `boolean` | `no` | Indicates whether or not the concurrent [`tasks`](#task) are racing against each other, with a single possible winner, which sets the composite task's output.<br>*If set to `false`, the task returns an array that includes the outputs from each branch, preserving the order in which the branches are declared.*<br>*If to `true`, the task returns only the output of the winning branch.*<br>*Defaults to `false`.* |

##### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: fork-example
  version: '0.1.0'
do:
  - raiseAlarm:
      fork:
        compete: true
        branches:
          - callNurse:
              call: http
              with:
                method: put
                endpoint: https://fake-hospital.com/api/v3/alert/nurses
                body:
                  patientId: ${ .patient.fullName }
                  room: ${ .room.number }
          - callDoctor:
              call: http
              with:
                method: put
                endpoint: https://fake-hospital.com/api/v3/alert/doctor
                body:
                  patientId: ${ .patient.fullName }
                  room: ${ .room.number }
```

#### Listen

Provides a mechanism for workflows to await and react to external events, enabling event-driven behavior within workflow systems. 

##### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| listen.to | [`eventConsumptionStrategy`](#event-consumption-strategy) | `yes` | Configures the [event(s)](https://cloudevents.io/) the workflow must listen to. |
| listen.read | `string` | `no` | Specifies how [events](https://cloudevents.io/) are read during the listen operation.<br>*Supported values are:*<br>*- `data`: Reads the [event's](https://cloudevents.io/) data.*<br>*- `envelope`: Reads the [event's](https://cloudevents.io/) envelope, including its [context attributes](https://github.com/cloudevents/spec/blob/main/cloudevents/spec.md#context-attributes).*<br>*- `raw`: Reads the [event's](https://cloudevents.io/) raw data.*<br>*Defaults to `data`.*|
| foreach | [`subscriptionIterator`](#subscription-iterator) | `no` | Configures the iterator, if any, for processing each consumed [event](https://cloudevents.io/). |

> [!NOTE]
> A `listen` task produces a sequentially ordered array of all the [events](https://cloudevents.io/) it has consumed, and potentially transformed using `foreach.output.as`.

> [!NOTE]
> When `foreach` is set, the configured operations for a [events](https://cloudevents.io/) must complete before moving on to the next one. As a result, consumed [events](https://cloudevents.io/) should be stored in a First-In-First-Out (FIFO) queue while awaiting iteration.

> [!WARNING]
> [Events](https://cloudevents.io/) consumed by an `until` clause should not be included in the task's output. These [events](https://cloudevents.io/) are used solely to determine when the until condition has been met, and they do not contribute to the result or data produced by the task itself


##### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: listen-example
  version: '0.1.0'
do:
  - callDoctor:
      listen:
        to:
          any:
          - with:
              type: com.fake-hospital.vitals.measurements.temperature
              data: ${ .temperature > 38 }
          - with:
              type: com.fake-hospital.vitals.measurements.bpm
              data: ${ .bpm < 60 or .bpm > 100 }
```

#### Raise

Intentionally triggers and propagates errors. By employing the "Raise" task, workflows can deliberately generate error conditions, allowing for explicit error handling and fault management strategies to be implemented.

##### Properties

| Name | Type | Required | Description |
|:--|:---:|:---:|:---|
| raise.error | `string`<br>[`error`](#error) | `yes` | Defines the [error](#error) to raise.<br>*If a `string`, must be the name of an [error](#error) defined in the [workflow's reusable components](#use).* |

##### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: raise-example
  version: '0.1.0'
do:
  - processTicket:
      switch:
        - highPriority:
            when: .ticket.priority == "high"
            then: escalateToManager
        - mediumPriority:
            when: .ticket.priority == "medium"
            then: assignToSpecialist
        - lowPriority:
            when: .ticket.priority == "low"
            then: resolveTicket
        - default:
            then: raiseUndefinedPriorityError
  - raiseUndefinedPriorityError:
      raise:
        error:
          type: https://fake.com/errors/tickets/undefined-priority
          status: 400
          instance: /raiseUndefinedPriorityError
          title: Undefined Priority
  - escalateToManager:
      call: http
      with:
        method: post
        endpoint: https://fake-ticketing-system.com/tickets/escalate
        body:
          ticketId: ${ .ticket.id }
  - assignToSpecialist:
      call: http
      with:
        method: post
        endpoint: https://fake-ticketing-system.com/tickets/assign
        body:
          ticketId: ${ .ticket.id }
  - resolveTicket:
      call: http
      with:
        method: post
        endpoint: https://fake-ticketing-system.com/tickets/resolve
        body:
          ticketId: ${ .ticket.id }
```

#### Run

Provides the capability to execute external [containers](#container-process), [shell commands](#shell-process), [scripts](#script-process), or [workflows](#workflow-process).

##### Properties

| Name | Type | Required | Description |
|:--|:---:|:---:|:---|
| run.container | [`container`](#container-process) | `no` | The definition of the container to run.<br>*Required if `script`, `shell` and `workflow` have not been set.* |
| run.script | [`script`](#script-process) | `no` | The definition of the script to run.<br>*Required if `container`, `shell` and `workflow` have not been set.* |
| run.shell | [`shell`](#shell-process) | `no` | The definition of the shell command to run.<br>*Required if `container`, `script` and `workflow` have not been set.* |
| run.workflow | [`workflow`](#workflow-process) | `no` | The definition of the workflow to run.<br>*Required if `container`, `script` and `shell` have not been set.* |
| await | `boolean` | `no` | Determines whether or not the process to run should be awaited for.<br>*When set to `false`, the task cannot wait for the process to complete and thus cannot output the process’s result. In this case, it should simply output its transformed input.*<br>*Defaults to `true`.* |
| return | `string` | `no` | Configures the output of the process.<br>*Supported values are:*<br>*- `stdout`: Outputs the content of the process **STDOUT**.*<br>*- `stderr`: Outputs the content of the process **STDERR**.*<br>*- `code`:  Outputs the process's **exit code**.*<br>*- `all`: Outputs the **exit code**, the **STDOUT** content and the **STDERR** content, wrapped into a new [processResult](#process-result) object.*<br>*- `none`: Does not output anything.*<br>*Defaults to `stdout`.* |

##### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: run-example
  version: '0.1.0'
do:
  - runContainer:
      run:
        container:
          image: fake-image

  - runScript:
      run:
        script:
          language: js
          code: >
            Some cool multiline script

  - runShell:
      run:
        shell:
          command: 'echo "Hello, ${ .user.name }"'

  - runWorkflow:
      run:
        workflow:
          namespace: another-one
          name: do-stuff
          version: '0.1.0'
          input: {}
```

##### Container Process

Enables the execution of external processes encapsulated within a containerized environment, allowing workflows to interact with and execute complex operations using containerized applications, scripts, or commands.

###### Properties

| Name | Type | Required | Description |
|:--|:---:|:---:|:---|
| image | `string` | `yes` | The name of the container image to run |
| name | `string` | `no` | A [runtime expression](dsl.md#runtime-expressions), if any, used to give specific name to the container. |
| command | `string` | `no` | The command, if any, to execute on the container |
| ports | `map` | `no` | The container's port mappings, if any  |
| volumes | `map` | `no` | The container's volume mappings, if any  |
| environment | `map` | `no` | A key/value mapping of the environment variables, if any, to use when running the configured process |
| stdin | `string` | `no` | A runtime expression, if any, passed as standard input to the command or default container CMD|
| arguments | `string[]` | `no` | A list of the arguments, if any, passed as argv to the command or default container CMD |
| lifetime | [`containerLifetime`](#container-lifetime) | `no` | An object used to configure the container's lifetime. |
| pullPolicy | `string` | `no` | Policy that controls how the container's image should be pulled from the registry.<br>*Supported values are `ifNotPresent`, `always` and `never`.*<br>*Defaults to `ifNotPresent`.* |

###### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: run-container-example
  version: '0.1.0'
do:
  - setInput:
      set:
        message: Hello World
  - runContainer:
      input:
        from: ${ .message }
      run:
        container:
          image: alpine
          stdin: ${ . }
          command: |
            input=$(cat)
            echo "STDIN was: $input"
            echo "ARGS are $1 $2"
          arguments:
          - Foo
          - Bar
          pullPolicy: always
```

> [!NOTE]
> When a `container process` is executed, runtime implementations are recommended to follow a predictable naming convention for the container name. This can improve monitoring, logging, and container lifecycle management.
>
> The Open Workflow Specification recommends using the following convention: `{workflow.name}-{uuid}.{workflow.namespace}-{task.name}`

##### Script Process

Enables the execution of custom scripts or code within a workflow, empowering workflows to perform specialized logic, data processing, or integration tasks by executing user-defined scripts written in various programming languages.

###### Properties

| Name | Type | Required | Description |
|:--|:---:|:---:|:---|
| language | `string` | `yes` | The language of the script to run.<br>*Supported values are: [`js`](https://tc39.es/ecma262/2024/) and [`python`](https://www.python.org/downloads/release/python-3131/).* |
| code | `string` | `no` | The script's code.<br>*Required if `source` has not been set.* |
| source | [externalResource](#external-resource) | `no` | The script's resource.<br>*Required if `code` has not been set.* |
| stdin | `string` | `no` | A runtime expression, if any, to the script as standard input (stdin).|
| arguments | `string[]` | `no` | A list of the arguments, if any, to the script as argv |
| environment | `map` | `no` | A key/value mapping of the environment variables, if any, to use when running the configured script process |


> [!WARNING]
> To ensure cross-compatibility, Open Workflow Specification strictly limits the versions of supported scripting languages. These versions may evolve with future releases. If you wish to use a different version of a language, you may do so by utilizing the [`container process`](#container-process).

**Supported languages**
| Language | Version |
|:-----------|:---------:|
| `JavaScript` | [`ES2024`](https://tc39.es/ecma262/2024/) |
| `Python` | [`3.13.x`](https://www.python.org/downloads/release/python-3131/) |

###### Examples

```yaml
document:
  dsl: 1.0.3
  namespace: examples
  name: run-script-example
  version: 1.0.0
do:
  - runScript:
      run:
        script:
          language: js
          arguments:
          - hello
          - world
          code: |
            const [_, __, arg0, arg1] = process.argv;
            console.log('arg > ', arg0, arg1)
```

##### Shell Process

Enables the execution of shell commands within a workflow, enabling workflows to interact with the underlying operating system and perform system-level operations, such as file manipulation, environment configuration, or system administration tasks.

###### Properties

| Name | Type | Required | Description |
|:--|:---:|:---:|:---|
| command | `string` | `yes` | The shell command to run |
| stdin | `string` | `no` | A runtime expression, if any, to the shell command as standard input (stdin).|
| arguments | `string[]` | `no` | A list of the arguments, if any, to the shell command as argv |
| environment | `map` | `no` | A key/value mapping of the environment variables, if any, to use when running the configured process |

###### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: run-shell-example
  version: '0.1.0'
do:
  - setInput:
      set:
        message: Hello World
  - runShell:
      input:
        from: ${ .message }
      run:
        shell:
          stdin: ${ . }
          command: |
            input=$(cat)
            echo "STDIN was: $input"
            echo "ARGS are $1 $2"
          arguments:
          - Foo
          - Bar
```

##### Workflow Process

Enables the invocation and execution of nested workflows within a parent workflow, facilitating modularization, reusability, and abstraction of complex logic or business processes by encapsulating them into standalone workflow units.

###### Properties

| Name | Type | Required | Description |
|:--|:---:|:---:|:---|
| namespace | `string` | `yes` | The namespace the workflow to run belongs to. |
| name | `string` | `yes` | The name of the workflow to run |
| version | `string` | `yes` | The version of the workflow to run. Defaults to `latest` |
| input | `any` | `no` | The data, if any, to pass as input to the workflow to execute. The value should be validated against the target workflow's input schema, if specified |

###### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: run-workflow-example
  version: '0.1.0'
do:
  - startWorkflow:
      run:
        workflow:
          namespace: another-one
          name: do-stuff
          version: '0.1.0'
          input:
            foo: bar
```

#### Set

A task used to set data.

##### Properties

| Name | Type | Required | Description |
|:-------|:------:|:----------:|:-------------|
| set | `map` <br> `string` | `yes` | The data to set.<br>*Can be an object or a direct runtime expression.* |

##### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: default
  name: set-example
  version: '0.1.0'
do:
  - setShape:
      set:
        shape: circle
        size: ${ .configuration.size }
        fill: ${ .configuration.fill }
  - setColor:
      set: ${ .configuration.color }      
```

#### Switch

Enables conditional branching within workflows, allowing them to dynamically select different paths based on specified conditions or criteria

##### Properties

| Name | Type | Required | Description |
|:--|:---:|:---:|:---|
| switch | [`case[]`](#switch-case) | `yes` | A name/value map of the cases to switch on  |

##### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: switch-example
  version: '0.1.0'
do:
  - processOrder:
      switch:
        - case1:
            when: .orderType == "electronic"
            then: processElectronicOrder
        - case2:
            when: .orderType == "physical"
            then: processPhysicalOrder
        - default:
            then: handleUnknownOrderType
  - processElectronicOrder:
      do:
        - validatePayment:
            call: http
            with:
              method: post
              endpoint: https://fake-payment-service.com/validate
        - fulfillOrder:
            call: http
            with:
              method: post
              endpoint: https://fake-fulfillment-service.com/fulfill
      then: exit
  - processPhysicalOrder:
      do:
        - checkInventory:
            call: http
            with:
              method: get
              endpoint: https://fake-inventory-service.com/inventory
        - packItems:
            call: http
            with:
              method: post
              endpoint: https://fake-packaging-service.com/pack
        - scheduleShipping:
            call: http
            with:
              method: post
              endpoint: https://fake-shipping-service.com/schedule
      then: exit
  - handleUnknownOrderType:
      do:
        - logWarning:
            call: http
            with:
              method: post
              endpoint: https://fake-logging-service.com/warn
        - notifyAdmin:
            call: http
            with:
              method: post
              endpoint: https://fake-notification-service.com/notify
```

##### Switch Case

Defines a switch case, encompassing a condition for matching and an associated action to execute upon a match.

| Name | Type | Required | Description |
|:--|:---:|:---:|:---|
| when | `string` | `no` | A runtime expression used to determine whether or not the case matches.<br>*If not set, the case will be matched by default if no other case match.*<br>*Note that there can be only one default case, all others **MUST** set a condition.*
| then | [`flowDirective`](#flow-directive) | `yes` | The flow directive to execute when the case matches. |

#### Try

Serves as a mechanism within workflows to handle errors gracefully, potentially retrying failed tasks before proceeding with alternate ones.

##### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| try | [`map[string, task]`](#task) | `yes` | The task(s) to perform. |
| catch | [`catch`](#catch) | `yes` | Configures the errors to catch and how to handle them. |

##### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: try-example
  version: '0.1.0'
do:
  - trySomething:
      try:
        - invalidHttpCall:
            call: http
            with:
              method: get
              endpoint: https://
      catch:
        errors:
          with:
            type: https://serverlessworkflow.io.io/dsl/errors/types/communication
            status: 503
        as: error
        retry:
          delay:
            seconds: 3
          backoff:
            exponential: {}
          limit:
            attempt:
              count: 5
```

##### Catch

Defines the configuration of a catch clause, which a concept used to catch errors.

###### Properties

| Name | Type | Required | Description |
|:--|:---:|:---:|:---|
| errors.with | [`errorFilter`](#error) | `no` | A static filter, used to catch only the errors whose properties match the specified values. |
| as | `string` | `no` | The name of the runtime expression variable to save the error as. Defaults to 'error'. |
| when | `string`| `no` | A runtime expression used to determine whether or not to catch the filtered error. |
| exceptWhen | `string` | `no` | A runtime expression used to determine whether or not to catch the filtered error. |
| retry | `string`<br>[`retryPolicy`](#retry) | `no` | The [`retry policy`](#retry) to use, if any, when catching [`errors`](#error).<br>*If a `string`, must be the name of a [retry policy](#retry) defined in the [workflow's reusable components](#use).* |
| do | [`map[string, task]`](#task) | `no` | The definition of the task(s) to run when catching an error. |

#### Wait

Allows workflows to pause or delay their execution for a specified period of time.

##### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| wait | `string`<br>[`duration`](#duration) | `yes` | The amount of time to wait.<br>If a `string`, must be a valid [ISO 8601](#) duration expression. |

##### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: wait-example
  version: '0.1.0'
do:
  - waitAWhile:
      wait:
        seconds: 10
```

### Flow Directive

Flow Directives are commands within a workflow that dictate its progression.

| Directive | Description |
| --------- | ----------- |
| `"continue"` | Instructs the workflow to proceed with the next task in line. This action may conclude the execution of a particular workflow or branch if there are not task defined after the continue one. |
| `"exit"` | Completes the current scope's execution, potentially terminating the entire workflow if the current task resides within the main `do` scope. |
| `"end"` | Provides a graceful conclusion to the workflow execution, signaling its completion explicitly. |
| `string` | Continues the workflow at the task with the specified name. |

> [!WARNING]
> Flow directives may only redirect to tasks declared within their own scope. In other words, they cannot target tasks at a different depth.

### Lifecycle Events

Lifecycle events are [cloud events](https://github.com/cloudevents/spec) used to notify users and external services about key state changes in workflows and tasks.

#### Workflow Lifecycle Events

##### Workflow Started Event

The data carried by the cloud event that notifies that a workflow has started.

###### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| name | `string` | `yes` | The qualified name of the workflow that has started. |
| definition | [`workflowDefinitionReference`](#workflow-definition-reference) | `yes` | An object that describes the definition of the workflow that has started. |
| startedAt | `dateTime` | `yes` | The date and time at which the workflow has started. |

###### Examples

```yaml
name: orderPetWorkflow-ix7iryakiem8j.samples
definition:
  name: orderPetWorkflow
  namespace: samples
  version: '1.0.0'
startedAt: '2024-07-26T16:59:57-05:00'
```

##### Workflow Suspended Event

The data carried by the cloud event that notifies that the execution of a workflow has been suspended.

###### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| name | `string` | `yes` | The qualified name of the workflow that has been suspended. |
| suspendedAt | `dateTime` | `yes` | The date and time at which the workflow has been suspended. |

###### Examples

```yaml
name: orderPetWorkflow-ix7iryakiem8j.samples
suspendedAt: '2024-07-26T16:59:57-05:00'
```

##### Workflow Resumed Event

The data carried by the cloud event that notifies that notifies that a workflow has been resumed.

###### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| name | `string` | `yes` | The qualified name of the workflow that has been resumed. |
| resumedAt | `dateTime` | `yes` | The date and time at which the workflow has been resumed. |

###### Examples

```yaml
name: orderPetWorkflow-ix7iryakiem8j.samples
resumedAt: '2024-07-26T16:59:57-05:00'
```

##### Workflow Correlation Started Event

The data carried by the cloud event that notifies that a workflow has started correlating events.

###### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| name | `string` | `yes` | The qualified name of the workflow that has started correlating events. |
| startedAt | `dateTime` | `yes` | The date and time at which the workflow has started correlating events. |

###### Examples

```yaml
name: orderPetWorkflow-ix7iryakiem8j.samples
startedAt: '2024-07-26T16:59:57-05:00'
```

##### Workflow Correlation Completed Event

The data carried by the cloud event that notifies that a workflow has completed correlating events.

###### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| name | `string` | `yes` | The qualified name of the workflow that has completed correlating events. |
| completedAt | `dateTime` | `yes` | The date and time at which the workflow has completed correlating events. |
| correlationKeys | `map` | `no` | A key/value mapping, if any, of the resolved correlation keys. |

###### Examples

```yaml
name: orderPetWorkflow-ix7iryakiem8j.samples
completedAt: '2024-07-26T16:59:57-05:00'
correlationKeys:
  petId: xt84hj202q14s
  orderId: '0a7f8581-acb9-4133-a378-0460c98ea60c'
```

##### Workflow Cancelled Event

The data carried by the cloud event that notifies that a workflow has been cancelled.

###### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| name | `string` | `yes` | The qualified name of the workflow that has been cancelled. |
| cancelledAt | `dateTime` | `yes` | The date and time at which the workflow has been cancelled. |

###### Examples

```yaml
name: orderPetWorkflow-ix7iryakiem8j.samples
cancelledAt: '2024-07-26T16:59:57-05:00'
```

##### Workflow Faulted Event

The data carried by the cloud event that notifies that a workflow has faulted.

###### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| name | `string` | `yes` | The qualified name of the workflow that has faulted. |
| faultedAt | `dateTime` | `yes` | The date and time at which the workflow has faulted. |
| error | [`error`](#error) | `yes` | The error that has cause the workflow to fault. |

###### Examples

```yaml
name: orderPetWorkflow-ix7iryakiem8j.samples
faultedAt: '2024-07-26T16:59:57-05:00'
error:
  type: https://serverlessworkflow.io/spec/1.0.0/errors/communication
  title: Service Not Available
  status: 503
```

##### Workflow Completed Event

The data carried by the cloud event that notifies that a workflow ran to completion.

###### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| name | `string` | `yes` | The qualified name of the workflow ran to completion. |
| completedAt | `dateTime` | `yes` | The date and time at which the workflow ran to completion. |
| output | `map` | `no` | The workflow's output, if any. |

###### Examples

```yaml
name: orderPetWorkflow-ix7iryakiem8j.samples
completedAt: '2024-07-26T16:59:57-05:00'
output:
  orderId: '0a7f8581-acb9-4133-a378-0460c98ea60c'
  petId: xt84hj202q14s
  status: placed
```

##### Workflow Status Changed Event

The data carried by the cloud event that notifies that the status phase of a workflow has changed.

###### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| name | `string` | `yes` | The qualified name of the workflow which's status phase has changed. |
| updatedAt | `dateTime` | `yes` | The date and time at which the workflow's status phase has changed. |
| status | `string` | The workflow's current [status phase](https://github.com/serverlessworkflow/specification/blob/main/dsl.md#status-phases). |

###### Examples

```yaml
name: orderPetWorkflow-ix7iryakiem8j.samples
updatedAt: '2024-07-26T16:59:57-05:00'
status: completed
```

#### Task Lifecycle Events

##### Task Created Event

The data carried by the cloud event that notifies that a task has been created.

###### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| workflow | `string` | `yes` | The qualified name of the workflow the task that has been created belongs to. |
| task | `uri` | `yes` | A JSON Pointer that references the task that has been created. |
| createdAt | `dateTime` | `yes` | The date and time at which the task has been created. |

###### Examples

```yaml
workflow: orderPetWorkflow-ix7iryakiem8j.samples
task: '/do/1/initialize'
createdAt: '2024-07-26T16:59:57-05:00'
```

##### Task Started Event

The data carried by the cloud event that notifies that a task has started.

###### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| workflow | `string` | `yes` | The qualified name of the workflow the task that has started belongs to. |
| task | `uri` | `yes` | A JSON Pointer that references the task that has started. |
| startedAt | `dateTime` | `yes` | The date and time at which the task has started. |

###### Examples

```yaml
workflow: orderPetWorkflow-ix7iryakiem8j.samples
task: '/do/1/initialize'
startedAt: '2024-07-26T16:59:57-05:00'
```

##### Task Suspended Event

The data carried by the cloud event that notifies that the execution of a task has been suspended.

###### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| workflow | `string` | `yes` | The qualified name of the workflow the task that has been suspended belongs to. |
| task | `uri` | `yes` | A JSON Pointer that references the task that has been suspended. |
| suspendedAt | `dateTime` | `yes` | The date and time at which the task has been suspended. |

###### Examples

```yaml
workflow: orderPetWorkflow-ix7iryakiem8j.samples
task: '/do/1/initialize'
suspendedAt: '2024-07-26T16:59:57-05:00'
```

##### Task Resumed Event

The data carried by the cloud event that notifies that notifies that a task has been resumed.

###### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| workflow | `string` | `yes` | The qualified name of the workflow the task that has been resumed belongs to. |
| task | `uri` | `yes` | A JSON Pointer that references the task that has been resumed. |
| resumedAt | `dateTime` | `yes` | The date and time at which the task has been resumed. |

###### Examples

```yaml
workflow: orderPetWorkflow-ix7iryakiem8j.samples
task: '/do/1/initialize'
resumedAt: '2024-07-26T16:59:57-05:00'
```

##### Task Retried Event

The data carried by the cloud event that notifies that notifies that a task is being retried.

###### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| workflow | `string` | `yes` | The qualified name of the workflow the task that is being retried belongs to. |
| task | `uri` | `yes` | A JSON Pointer that references the task that is being retried. |
| retriedAt | `dateTime` | `yes` | The date and time at which the task has been retried. |

###### Examples

```yaml
workflow: orderPetWorkflow-ix7iryakiem8j.samples
task: '/do/1/initialize'
retriedAt: '2024-07-26T16:59:57-05:00'
```

##### Task Cancelled Event

The data carried by the cloud event that notifies that a task has been cancelled.

###### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| workflow | `string` | `yes` | The qualified name of the workflow the task that has been cancelled belongs to. |
| task | `uri` | `yes` | A JSON Pointer that references the task that has been cancelled. |
| cancelledAt | `dateTime` | `yes` | The date and time at which the task has been cancelled. |

###### Examples

```yaml
workflow: orderPetWorkflow-ix7iryakiem8j.samples
task: '/do/1/initialize'
cancelledAt: '2024-07-26T16:59:57-05:00'
```

##### Task Faulted Event

The data carried by the cloud event that notifies that a task has been faulted.

###### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| workflow | `string` | `yes` | The qualified name of the workflow the task that has faulted belongs to. |
| task | `uri` | `yes` | A JSON Pointer that references the task that has faulted. |
| faultedAt | `dateTime` | `yes` | The date and time at which the task has faulted. |
| error | [`error`](#error) | `yes` | The error that has cause the task to fault. |

###### Examples

```yaml
workflow: orderPetWorkflow-ix7iryakiem8j.samples
task: '/do/1/initialize'
faultedAt: '2024-07-26T16:59:57-05:00'
error:
  type: https://serverlessworkflow.io/spec/1.0.0/errors/communication
  title: Service Not Available
  status: 503
```

##### Task Completed Event

The data carried by the cloud event that notifies that a task ran to completion.

###### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| workflow | `string` | `yes` | The qualified name of the workflow the task that ran to completion belongs to. |
| task | `uri` | `yes` | A JSON Pointer that references the task that ran to completion. |
| completedAt | `dateTime` | `yes` | The date and time at which the task ran to completion. |
| output | `map` | `no` | The task's output, if any. |

###### Examples

```yaml
workflow: orderPetWorkflow-ix7iryakiem8j.samples
task: '/do/1/initialize'
completedAt: '2024-07-26T16:59:57-05:00'
output:
  orderId: '0a7f8581-acb9-4133-a378-0460c98ea60c'
  petId: xt84hj202q14s
  status: placed
```

##### Task Status Changed Event

The data carried by the cloud event that notifies that the status phase of a task has changed.

###### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| workflow | `string` | `yes` | The qualified name of the workflow the task which's status phase has changed belongs to. |
| task | `uri` | `yes` | A JSON Pointer that references the task which's status phase has changed. |
| updatedAt | `dateTime` | `yes` | The date and time at which the task's status phase has changed. |
| status | `string` | The task's current [status phase](https://github.com/serverlessworkflow/specification/blob/main/dsl.md#status-phases). |

###### Examples

```yaml
workflow: orderPetWorkflow-ix7iryakiem8j.samples
task: '/do/1/initialize'
updatedAt: '2024-07-26T16:59:57-05:00'
status: completed
```

### External Resource

Defines an external resource.

#### Properties

| Property | Type | Required | Description |
|----------|:----:|:--------:|-------------|
| name | `string` | `no` | The name, if any, of the defined resource. |
| endpoint | [`endpoint`](#endpoint) | `yes` | The endpoint at which to get the defined resource. |

##### Examples

```yaml
name: sample-resource
endpoint:
  uri: https://fake.com/resource/0123
  authentication:
    basic:
      username: admin
      password: 1234
```

### Authentication

Defines the mechanism used to authenticate users and workflows attempting to access a service or a resource.

#### Properties

| Property | Type | Required | Description |
|----------|:----:|:--------:|-------------|
| use | `string` | `no` | The name of the top-level authentication definition to use. Cannot be used by authentication definitions defined at top level. |
| basic | [`basicAuthentication`](#basic-authentication) | `no` | The `basic` authentication scheme to use, if any.<br>Required if no other property has been set, otherwise ignored. |
| bearer | [`bearerAuthentication`](#bearer-authentication) | `no` | The `bearer` authentication scheme to use, if any.<br>Required if no other property has been set, otherwise ignored. |
| digest | [`digestAuthentication`](#digest-authentication) | `no` | The `digest` authentication scheme to use, if any.<br>Required if no other property has been set, otherwise ignored. |
| oauth2 | [`oauth2`](#oauth2-authentication) | `no` | The `oauth2` authentication scheme to use, if any.<br>Required if no other property has been set, otherwise ignored. |
| oidc | [`oidc`](#openidconnect-authentication) | `no` | The `oidc` authentication scheme to use, if any.<br>Required if no other property has been set, otherwise ignored. |

##### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: authentication-example
  version: '0.1.0'
use:
  secrets:
    - usernamePasswordSecret
  authentications:
    sampleBasicFromSecret:
      basic:
        use: usernamePasswordSecret
do:
  - sampleTask:
      call: http
      with:
        method: get
        endpoint: 
          uri: https://secured.fake.com/sample
          authentication:
            use: sampleBasicFromSecret
```

#### Basic Authentication

Defines the fundamentals of a 'basic' authentication.

##### Properties

| Property | Type | Required | Description |
|----------|:----:|:--------:|-------------|
| username | `string` | `yes` | The username to use. |
| password | `string` | `yes` | The password to use. |

##### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: basic-authentication-example
  version: '0.1.0'
use:
  authentications:
    sampleBasic:
      basic:
        username: admin
        password: password123
do:
  - sampleTask:
      call: http
      with:
        method: get
        endpoint: 
          uri: https://secured.fake.com/sample
          authentication: 
            use: sampleBasic
```

#### Bearer Authentication

Defines the fundamentals of a 'bearer' authentication

##### Properties

| Property | Type | Required | Description |
|----------|:----:|:--------:|-------------|
| token | `string` | `yes` | The bearer token to use. |

##### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: bearer-authentication-example
  version: '0.1.0'
do:
  - sampleTask:
      call: http
      with:
        method: get
        endpoint: 
          uri: https://secured.fake.com/sample
          authentication:
            bearer:
              token: ${ .user.token }
```

#### Digest Authentication

Defines the fundamentals of a 'digest' authentication.

##### Properties

| Property | Type | Required | Description |
|----------|:----:|:--------:|-------------|
| username | `string` | `yes` | The username to use. |
| password | `string` | `yes` | The password to use. |

##### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: digest-authentication-example
  version: '0.1.0'
use:
  authentications:
    sampleDigest:
      digest:
        username: admin
        password: password123
do:
  - sampleTask:
      call: http
      with:
        method: get
        endpoint: 
          uri: https://secured.fake.com/sample
          authentication: 
            use: sampleDigest
```

#### OAUTH2 Authentication

Defines the fundamentals of an 'oauth2' authentication.

##### Properties

| Name | Type | Required | Description |
|:-----|:----:|:--------:|:------------|
| authority | `uri-template` | `yes` | The URI that references the authority to use when making OAuth2 calls. |
| endpoints.token | `uri-template` | `no` | The relative path to the endpoint for OAuth2 token requests.<br>Defaults to `/oauth2/token`. |
| endpoints.revocation | `uri-template` | `no` | The relative path to the endpoint used to invalidate tokens.<br>Defaults to `/oauth2/revoke`. |
| endpoints.introspection | `uri-template` | `no` | The relative path to the endpoint used to validate and obtain information about a token, typically to check its validity and associated metadata.<br>Defaults to `/oauth2/introspect`. | 
| grant | `string` | `yes` | The grant type to use.<br>Supported values are `authorization_code`, `client_credentials`, `password`, `refresh_token` and `urn:ietf:params:oauth:grant-type:token-exchange`. |
| client.id | `string` | `no` | The client id to use.<br>Required if the `client.authentication` method has **not** been set to `none`. |
| client.secret | `string` | `no` | The client secret to use, if any. |
| client.assertion | `string` | `no` | A JWT containing a signed assertion with your application credentials.<br>Required when `client.authentication` has been set to `private_key_jwt`. |
| client.authentication | `string` | `no` | The client authentication method to use.<br>Supported values are `client_secret_basic`, `client_secret_post`, `client_secret_jwt`, `private_key_jwt` or `none`.<br>Defaults to `client_secret_post`. |
| request.encoding | `string` | `no` | The encoding of the token request.<br>Supported values are `application/x-www-form-urlencoded` and `application/json`.<br>Defaults to application/x-www-form-urlencoded. |
| issuers | `string[]` | `no` | A list that contains valid issuers that will be used to check against the issuer of generated tokens. |
| scopes | `string[]` | `no` | The scopes, if any, to request the token for. |
| audiences | `string[]` | `no` | The audiences, if any, to request the token for. |
| username | `string` | `no` | The username to use. Used only if the grant type is `Password`. |
| password | `string` | `no` | The password to use. Used only if the grant type is `Password`. |
| subject | [`oauth2Token`](#oauth2-token) | `no` | The security token that represents the identity of the party on behalf of whom the request is being made. |
| actor | [`oauth2Token`](#oauth2-token) | `no` | The security token that represents the identity of the acting party. |

##### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: oauth2-authentication-example
  version: '0.1.0'
do:
  - sampleTask:
      call: http
      with:
        method: get
        endpoint: 
          uri: https://secured.fake.com/sample
          authentication:
            oauth2:
              authority: http://keycloak/realms/fake-authority
              endpoints:
                token: /oauth2/token
              grant: client_credentials
              client:
                id: workflow-runtime
                secret: "**********"
              scopes: [ api ]
              audiences: [ runtime ]
```

##### OAUTH2 Token

Represents the definition of an OAUTH2 token

###### Properties

| Property | Type | Required | Description |
|----------|:----:|:--------:|-------------|
| token | `string` | `yes` | The security token to use to use. |
| type | `string` | `yes` | The type of security token to use. |

#### OpenIdConnect Authentication

Defines the fundamentals of an 'oidc' authentication.

##### Properties

| Name | Type | Required | Description |
|:-----|:----:|:--------:|:------------|
| authority | `uri-template` | `yes` | The URI that references the authority to use when making OpenIdConnect calls. |
| grant | `string` | `yes` | The grant type to use.<br>Supported values are `authorization_code`, `client_credentials`, `password`, `refresh_token` and `urn:ietf:params:oauth:grant-type:token-exchange`. |
| client.id | `string` | `no` | The client id to use.<br>Required if the `client.authentication` method has **not** been set to `none`. |
| client.secret | `string` | `no` | The client secret to use, if any. |
| client.assertion | `string` | `no` | A JWT containing a signed assertion with your application credentials.<br>Required when `client.authentication` has been set to `private_key_jwt`. |
| client.authentication | `string` | `no` | The client authentication method to use.<br>Supported values are `client_secret_basic`, `client_secret_post`, `client_secret_jwt`, `private_key_jwt` or `none`.<br>Defaults to `client_secret_post`. |
| request.encoding | `string` | `no` | The encoding of the token request.<br>Supported values are `application/x-www-form-urlencoded` and `application/json`.<br>Defaults to application/x-www-form-urlencoded. |
| issuers | `string[]` | `no` | A list that contains valid issuers that will be used to check against the issuer of generated tokens. |
| scopes | `string[]` | `no` | The scopes, if any, to request the token for. |
| audiences | `string[]` | `no` | The audiences, if any, to request the token for. |
| username | `string` | `no` | The username to use. Used only if the grant type is `Password`. |
| password | `string` | `no` | The password to use. Used only if the grant type is `Password`. |
| subject | [`oauth2Token`](#oauth2-token) | `no` | The security token that represents the identity of the party on behalf of whom the request is being made. |
| actor | [`oauth2Token`](#oauth2-token) | `no` | The security token that represents the identity of the acting party. |

##### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: oidc-authentication-example
  version: '0.1.0'
do:
  - sampleTask:
      call: http
      with:
        method: get
        endpoint: 
          uri: https://secured.fake.com/sample
          authentication:
            oidc:
              authority: http://keycloak/realms/fake-authority/.well-known/openid-configuration
              grant: client_credentials
              client:
                id: workflow-runtime
                secret: "**********"
              scopes: [ api ]
              audiences: [ runtime ]
```

### Catalog

A **resource catalog** is an external collection of reusable components, such as functions, that can be referenced and imported into workflows. Catalogs allow workflows to integrate with externally defined resources, making it easier to manage reuse and versioning across different workflows.

Each catalog is defined by an `endpoint` property, specifying the root URL where the resources are hosted, enabling workflows to access external functions and services. For portability, catalogs must adhere to a specific file structure, as defined [here](https://github.com/serverlessworkflow/catalog?tab=readme-ov-file#structure).

For more information about catalogs, refer to the [Open Workflow DSL document](https://github.com/serverlessworkflow/specification/blob/main/dsl.md#catalogs).

#### Properties

| Property | Type | Required | Description |
|----------|:----:|:--------:|-------------|
| endpoint | [`endpoint`](#endpoint) | `yes` | The endpoint that defines the root URL at which the catalog is located. |

#### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: catalog-example
  version: '0.1.0'
use:
  catalogs:
    global:
      endpoint:
        uri: https://github.com/serverlessworkflow/catalog
        authentication:
          basic:
            username: user
            password: '012345'
do:
  - log:
      call: log:0.5.2@global
      with:
        message: The cataloged custom function has been successfully called
```

### Extension

Holds the definition for extending functionality, providing configuration options for how an extension extends and interacts with other components.

Extensions enable the execution of tasks prior to those they extend, offering the flexibility to potentially bypass the extended task entirely using an [`exit` workflow directive](#flow-directive).

#### Properties

| Property | Type | Required | Description |
|----------|:----:|:--------:|-------------|
| extend |  `string` | `yes` | The type of task to extend<br>Supported values are: `call`, `composite`, `emit`, `for`, `listen`, `raise`, `run`, `set`, `switch`, `try`, `wait` and `all` |
| when | `string` | `no` | A runtime expression used to determine whether or not the extension should apply in the specified context |
| before | [`task[]`](#task) | `no` | The list of tasks to execute, if any, before the extended task |
| after | [`task[]`](#task) | `no` | The list of tasks to execute, if any, after the extended task |

#### Examples

*Perform logging before and after any non-extension task is run:*
```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: logging-extension-example
  version: '0.1.0'
use:
  extensions:
    - logging:
        extend: all
        before:
          - sendLog:
              call: http
              with:
                method: post
                endpoint: https://fake.log.collector.com
                body:
                  message: ${ "Executing task '\($task.reference)'..." }
        after:
          - sendLog:
              call: http
              with:
                method: post
                endpoint: https://fake.log.collector.com
                body:
                  message: ${ "Executed task '\($task.reference)'..." }
do:
  - sampleTask:
      call: http
      with:
        method: get
        endpoint: https://fake.com/sample
```

*Intercept HTTP calls to 'https://mocked.service.com' and mock its response:*
```yaml
document:  
  dsl: '1.0.3'
  namespace: test
  name: intercept-extension-example
  version: '0.1.0'
use:
  extensions:
    - mockService:
        extend: call
        when: $task.call == "http" and ($task.with.uri != null and ($task.with.uri | startswith("https://mocked.service.com"))) or ($task.with.endpoint.uri != null and ($task.with.endpoint.uri | startswith("https://mocked.service.com")))
        before:
          - intercept:
              set:
                statusCode: 200
                headers:
                  Content-Type: application/json
                content:
                  foo:
                    bar: baz
              then: exit #using this, we indicate to the workflow we want to exit the extended task, thus just returning what we injected
do:
  - sampleTask:
      call: http
      with:
        method: get
        endpoint: https://fake.com/sample
```

### Error

Defines the [Problem Details RFC](https://datatracker.ietf.org/doc/html/rfc7807) compliant description of an error.

#### Properties

| Property | Type | Required | Description |
|----------|:----:|:--------:|-------------|
| type | [`uri-template`](#uri-template) | `yes` | A URI reference that identifies the [`error`](#error) type. <br><u>For cross-compatibility concerns, it is strongly recommended to use [Standard Error Types](#standard-error-types) whenever possible.<u><br><u>Runtimes **MUST** ensure that the property has been set when raising or escalating the [`error`](#error).<u> |
| status | `integer` | `yes` | The status code generated by the origin for this occurrence of the [`error`](#error).<br><u>For cross-compatibility concerns, it is strongly recommended to use [HTTP Status Codes](https://datatracker.ietf.org/doc/html/rfc7231#section-6) whenever possible.<u><br><u>Runtimes **MUST** ensure that the property has been set when raising or escalating the [`error`](#error).<u> |
| instance | `string` | `no` | A [JSON Pointer](https://datatracker.ietf.org/doc/html/rfc6901) used to reference the component the [`error`](#error) originates from.<br><u>Runtimes **MUST** set the property when raising or escalating the [`error`](#error). Otherwise ignore.<u> |
| title | `string` | `no` | A short, human-readable summary of the [`error`](#error) or a [runtime expression](dsl.md#runtime-expressions) |
| detail | `string` | `no` | A human-readable explanation specific to this occurrence of the [`error`](#error) or a [runtime expression](dsl.md#runtime-expressions) |

#### Examples

```yaml
type: https://serverlessworkflow.io/spec/1.0.0/errors/communication
title: Service Not Available
status: 503
```

#### Standard Error Types

Standard error types serve the purpose of categorizing errors consistently across different runtimes, facilitating seamless migration from one runtime environment to another.

| Type | Status¹ | Description |
|------|:-------:|-------------|
| [https://serverlessworkflow.io/spec/1.0.0/errors/configuration](#) | `400` | Errors resulting from incorrect or invalid configuration settings, such as missing or misconfigured environment variables, incorrect parameter values, or configuration file errors. |
| [https://serverlessworkflow.io/spec/1.0.0/errors/validation](#) | `400` | Errors arising from validation processes, such as validation of input data, schema validation failures, or validation constraints not being met. These errors indicate that the provided data or configuration does not adhere to the expected format or requirements specified by the workflow. |
| [https://serverlessworkflow.io/spec/1.0.0/errors/expression](#) | `400` | Errors occurring during the evaluation of runtime expressions, such as invalid syntax or unsupported operations. |
| [https://serverlessworkflow.io/spec/1.0.0/errors/authentication](#) | `401` | Errors related to authentication failures. |
| [https://serverlessworkflow.io/spec/1.0.0/errors/authorization](#) | `403` | Errors related to unauthorized access attempts or insufficient permissions to perform certain actions within the workflow. |
| [https://serverlessworkflow.io/spec/1.0.0/errors/timeout](#) | `408` | Errors caused by timeouts during the execution of tasks or during interactions with external services. |
| [https://serverlessworkflow.io/spec/1.0.0/errors/communication](#) | `500` | Errors  encountered while communicating with external services, including network errors, service unavailable, or invalid responses. |
| [https://serverlessworkflow.io/spec/1.0.0/errors/runtime](#) | `500` | Errors occurring during the runtime execution of a workflow, including unexpected exceptions, errors related to resource allocation, or failures in handling workflow tasks. These errors typically occur during the actual execution of workflow components and may require runtime-specific handling and resolution strategies. |

¹ *Default value. The `status code` that best describe the error should always be used.*

### Event Consumption Strategy

Represents the configuration of an event consumption strategy.

#### Properties

| Property | Type | Required | Description |
|----------|:----:|:--------:|-------------|
| all | [`eventFilter[]`](#event-filter) | `no` | Configures the workflow to wait for all defined events before resuming execution.<br>*Required if `any` and `one` have not been set.* |
| any | [`eventFilter[]`](#event-filter) | `no` | Configures the workflow to wait for any of the defined events before resuming execution.<br>*Required if `all` and `one` have not been set.*<br>*If empty, listens to all incoming events* |
| one | [`eventFilter`](#event-filter) | `no` | Configures the workflow to wait for the defined event before resuming execution.<br>*Required if `all` and `any` have not been set.* |
| until | `string`<br>[`eventConsumptionStrategy`](#event-consumption-strategy) | `no` | Configures the [runtime expression](dsl.md#runtime-expressions) condition or the events that must be consumed to stop listening.<br>*Only applies if `any` has been set, otherwise ignored.*<br>*If not present, once any event is received, it proceeds to the next task.* |

### Event Properties

An event object typically includes details such as the event type, source, timestamp, and unique identifier along with any relevant data payload. The [CloudEvents specification](https://cloudevents.io/), favored by Open Workflow Specification, standardizes this structure to ensure interoperability across different systems and services.

#### Properties

| Property | Type | Required | Description |
|----------|:----:|:--------:|-------------|
| id | `string` | `no` | Identifies the event. `source` + `id` is unique for each distinct event.<br>*Required when emitting an event using `emit.event.with`.* |
| source | `string` | `no` | An URI formatted string, or [runtime expression](dsl.md#runtime-expressions), that identifies the context in which an event happened. `source` + `id` is unique for each distinct event.<br>*Required when emitting an event using `emit.event.with`.* |
| type | `string` | `no` | Describes the type of event related to the originating occurrence.<br>*Required when emitting an event using `emit.event.with`.* |
| time | `string` | `no` | A string, or [runtime expression](dsl.md#runtime-expressions), representing the timestamp of when the occurrence happened. |
| subject | `string` | `no` | Describes the subject of the event in the context of the event producer. |
| datacontenttype | `string` | `no` | Content type of `data` value. If omitted, it implies the `data` is a JSON value conforming to the "application/json" media type. |
| dataschema | `string` | `no` | An URI formatted string, or [runtime expression](dsl.md#runtime-expressions), that identifies the schema that `data` adheres to. |
| data | `any` | `no` | The event payload. |

*Additional properties can be supplied, see the CloudEvents specification [documentation](https://github.com/cloudevents/spec/blob/main/cloudevents/spec.md#extension-context-attributes) for more info.*

*When used in an [`eventFilter`](#event-filter), at least one property must be supplied.*


### Event Filter

An event filter is a mechanism used to selectively process or handle events based on predefined criteria, such as event type, source, or specific attributes.

#### Properties

| Property | Type | Required | Description |
|----------|:----:|:--------:|-------------|
| with | [`eventProperties`](#event-properties) | `yes` | A name/value mapping of the attributes filtered events must define. Supports both regular expressions and runtime expressions.  |
| correlate | [`map[string, correlation]`](#correlation) | `no` | A name/definition mapping of the correlations to attempt when filtering events. |

### Correlation

A correlation is a link between events and data, established by mapping event attributes to specific data attributes, allowing for coordinated processing or handling based on event characteristics.

#### Properties

| Property | Type | Required | Description |
|----------|:----:|:--------:|-------------|
| from | `string` | `yes` | A runtime expression used to extract the correlation value from the filtered event. |
| expect | `string` | `no` | A constant or a runtime expression, if any, used to determine whether or not the extracted correlation value matches expectations.<br>If not set, the first extracted value will be used as the correlation's expectation. |

### Retry

The Retry is a fundamental concept in the Open Workflow DSL, used to define the strategy for retrying a failed task when an error is encountered during execution. This policy provides developers with fine-grained control over how and when to retry failed tasks, enabling robust error handling and fault tolerance within workflows.

#### Properties

| Property | Type | Required | Description |
|----------|:----:|:--------:|-------------|
| when | `string` | `no` | A a runtime expression used to determine whether or not to retry running the task, in a given context. |
| exceptWhen | `string` | `no` | A runtime expression used to determine whether or not to retry running the task, in a given context. |
| delay | [`duration`](#duration) | `no` | The duration, if any, to wait between retry attempts. |
| limit | [`retry`](#retry-limit) | `no` | The limits, if any, to impose to the retry policy. |
| backoff | [`backoff`](#backoff) | `no` | The backoff strategy to use, if any. |
| jitter | [`jitter`](#jitter) | `no` | The parameters, if any, that control the randomness or variability of the delay between retry attempts. |

#### Retry Limit

The definition of a retry policy.

| Property | Type | Required | Description |
|----------|:----:|:--------:|-------------|
| attempt.count | `integer` | `no` | The maximum attempts count. |
| attempt.duration | [`duration`](#duration) | `no` | The duration limit, if any, for all retry attempts. | 
| duration | [`duration`](#duration) | `no` | The maximum duration, if any, during which to retry a given task. |

#### Backoff

The definition of a retry backoff strategy.

| Property | Type | Required | Description |
|----------|:----:|:--------:|-------------|
| constant | `object` | `no` | The definition of the constant backoff to use, if any.<br>*Required if `exponential` and `linear` are not set, otherwise ignored.* |
| exponential | `object` | `no` | The definition of the exponential backoff to use, if any.<br>*Required if `constant` and `linear` are not set, otherwise ignored.* |
| linear | `object` | `no` | The definition of the linear backoff to use, if any.<br>*Required if `constant` and `exponential` are not set, otherwise ignored.* |

#### Jitter

Represents the definition of the parameters that control the randomness or variability of a delay, typically between retry attempts

| Property | Type | Required | Description |
|----------|:----:|:--------:|-------------|
| from | [`duration`](#duration) | `yes` | The minimum duration of the jitter range. |
| to | [`duration`](#duration) | `yes` | The maximum duration of the jitter range. |

#### Examples

```yaml

```

### Input

Documents the structure - and optionally configures the transformation of - workflow/task input data.

It's crucial for authors to document the schema of input data whenever feasible. This documentation empowers consuming applications to provide contextual auto-suggestions when handling runtime expressions.

When set, runtimes must validate raw input data against the defined schema before applying transformations, unless defined otherwise.

#### Properties

| Property | Type | Required | Description |
|----------|:----:|:--------:|-------------|
| schema | [`schema`](#schema) | `no` | The [`schema`](#schema) used to describe and validate raw input data.<br>*Even though the schema is not required, it is strongly encouraged to document it, whenever feasible.* |
| from | `string`<br>`object` | `no` | A [runtime expression](dsl.md#runtime-expressions), if any, used to filter and/or mutate the workflow/task input.  |

#### Examples

```yaml
schema:
  format: json
  document:
    type: object
    properties:
      order:
        type: object
        required: [ pet ]
        properties:
          pet:
            type: object
            required: [ id ]
            properties:
              id:
                type: string
from: .order.pet
```

### Output

Documents the structure - and optionally configures the transformations of - workflow/task output data.

It's crucial for authors to document the schema of output data whenever feasible. This documentation empowers consuming applications to provide contextual auto-suggestions when handling runtime expressions.

When set, runtimes must validate output data against the defined schema after applying transformations, unless defined otherwise.

#### Properties

| Property | Type | Required | Description |
|----------|:----:|:--------:|-------------|
| schema | [`schema`](#schema) | `no` | The [`schema`](#schema) used to describe and validate output data.<br>*Even though the schema is not required, it is strongly encouraged to document it, whenever feasible.* |
| as | `string`<br>`object` | `no` | A [runtime expression](dsl.md#runtime-expressions), if any, used to filter and/or mutate the workflow/task output. |

#### Examples

```yaml
output:
  schema:
    format: json
    document:
      type: object
      properties:
        petId:
          type: string
      required: [ petId ]
  as:
    petId: '${ .pet.id }'
```

### Export

Certain task needs to set the workflow context to save the task output for later usage. Users set the content of the context through a runtime expression. The result of the expression is the new value of the context. The expression is evaluated against the transformed task output.

Optionally, the context might have an associated schema which is validated against the result of the expression.

#### Properties

| Property | Type | Required | Description |
|----------|:----:|:--------:|-------------|
| schema | [`schema`](#schema) | `no` | The [`schema`](#schema) used to describe and validate context.<br>*Included to handle the non frequent case in which the context has a known format.* |
| as | `string`<br>`object` | `no` | A runtime expression, if any, used to export the output data to the context. |

#### Examples

Merge the task output into the current context.

```yaml
as: '$context+.'
```

Replace the context with the task output.

```yaml
as: '.'
```

### Schema

Describes a data schema.

#### Properties

| Property | Type | Required | Description |
|----------|:----:|:--------:|-------------|
| format | `string` | `yes` | The schema format.<br>*Supported values are:*<br>*- `json`, which indicates the [JsonSchema](https://json-schema.org/) format.* |
| document | `object` | `no` | The inline schema document.<br>*Required if `resource` has not been set, otherwise ignored.* |
| resource | [`externalResource`](#external-resource) | `no` | The schema external resource.<br>*Required if `document` has not been set, otherwise ignored.* |

#### Examples

*Example of an inline JsonSchema:*
```yaml
format: json
document:
  type: object
  properties:
    id:
      type: string
    firstName:
      type: string
    lastName:
      type: string
  required: [ id, firstName, lastName ]
```

*Example of a JsonSchema based on an external resource:*
```yaml
format: json
resource:
  endpoint: https://test.com/fake/schema/json/document.json
```

### Timeout

Defines a workflow or task timeout.

#### Properties

| Property | Type | Required | Description |
|----------|:----:|:--------:|-------------|
| after | [`duration`](#duration) | `yes` | The duration after which the workflow or task times out.  |

#### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: default
  name: timeout-example
  version: '0.1.0'
do:
  - waitAMinute:
      wait:
        seconds: 60
timeout:
  after:
    seconds: 30
```

### Duration

Defines a duration. Durations can be defined through properties, with an ISO 8601 string or with a runtime expression that is evaluated to an ISO 8601 string

#### Properties

| Property | Type | Required | Description |
|----------|:----:|:--------:|-------------|
| days | `integer` | `no` | Number of days, if any. |
| hours | `integer` | `no` | Number of hours, if any. |
| minutes | `integer` | `no`| Number of minutes, if any. |
| seconds | `integer` | `no`| Number of seconds, if any. |
| milliseconds | `integer` | `no`| Number of milliseconds, if any. |

#### Examples

*Example of a duration of 2 hours, 15 minutes and 30 seconds:*
```yaml
hours: 2
minutes: 15
seconds: 30
```

### Endpoint

Describes an enpoint.

#### Properties

| Property | Type | Required | Description |
|----------|:----:|:--------:|-------------|
| uri | `string` | `yes` | The endpoint's URI. |
| authentication | [authentication](#authentication) | `no` | The authentication policy to use. |

### HTTP Response

Describes an HTTP response.

#### Properties

| Property | Type | Required | Description |
|----------|:----:|:--------:|-------------|
| request | [`request`](#http-request) | `yes` | The HTTP request associated with the HTTP response. |
| statusCode | `integer` | `yes` | The HTTP response status code. |
| headers | `map[string, string]` | `no` | The HTTP response headers, if any. |
| content | `any` | `no` | The HTTP response content, if any.<br>*If the request's content type is one of the following, should contain the deserialized response content. Otherwise, should contain the base-64 encoded response content, if any.*|

#### Examples

```yaml
request:
  method: get
  uri: https://petstore.swagger.io/v2/pet/1
  headers:
    Content-Type: application/json
headers:
  Content-Type: application/json
statusCode: 200
content:
  id: 1
  name: milou
  status: pending
```

### HTTP Request

Describes an HTTP request.

#### Properties

| Property | Type | Required | Description |
|----------|:----:|:--------:|-------------|
| method | `string` | `yes` | The request's method. |
| uri | `uri` | `yes` | The request's URI. |
| headers | `map[string, string]` | `no` | The HTTP request headers, if any. |

#### Examples

```yaml
method: get
uri: https://petstore.swagger.io/v2/pet/1
headers:
  Content-Type: application/json
```

### URI Template

The DSL has limited support for URI template syntax as defined by [RFC 6570](https://datatracker.ietf.org/doc/html/rfc6570). Specifically, only the [Simple String Expansion](https://datatracker.ietf.org/doc/html/rfc6570#section-3.2.2) is supported, which allows authors to embed variables in a URI.

To substitute a variable within a URI, use the `{}` syntax. The identifier inside the curly braces will be replaced with its value during runtime evaluation. If no value is found for the identifier, an empty string will be used.

This has the following limitations compared to runtime expressions:

- Only top-level properties can be interpolated within strings, thus identifiers are treated verbatim. This means that `{pet.id}` will be replaced with the value of the `"pet.id"` property, not the value of the `id` property of the `pet` property.
- The referenced variable must be of type `string`, `number`, `boolean`, or `null`. If the variable is of a different type an error with type `https://https://serverlessworkflow.io/spec/1.0.0/errors/expression` and status `400` will be raised.
- [Runtime expression arguments](./dsl.md#runtime-expression-arguments) are not available for string substitution.

#### Examples

```yaml
uri: https://petstore.swagger.io/v2/pet/{petId}
```

### Container Lifetime

Configures the lifetime of a container.

#### Properties

| Property | Type | Required | Description |
|----------|:----:|:--------:|-------------|
| cleanup | `string` | `yes` | The cleanup policy to use.<br>*Supported values are:<br>- `always`: the container is deleted immediately after execution.<br>-`never`: the runtime should never delete the container.<br>-`eventually`: the container is deleted after a configured amount of time after its execution.*<br>*Defaults to `never`.* |
| after | [`duration`](#duration) | `no` | The [`duration`](#duration), if any, after which to delete the container once executed.<br>*Required if `cleanup` has been set to `eventually`, otherwise ignored.* |
### Process Result

Describes the result of a process.

#### Properties

| Name | Type | Required | Description|
|:--|:---:|:---:|:---|
| code | `integer` | `yes` | The process's exit code. |
| stdout | `string` | `yes` | The process's **STDOUT** output. |
| stderr | `string` | `yes` | The process's **STDERR** output. |

#### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: run-container-example
  version: '0.1.0'
do:
  - runContainer:
      run:
        container:
          image: fake-image
          lifetime:
            cleanup: eventually
            after:
              minutes: 30
        return: stderr

  - runScript:
      run:
        script:
          language: js
          code: >
            Some cool multiline script
        return: code

  - runShell:
      run:
        shell:
          command: 'echo "Hello, ${ .user.name }"'
        return: all

  - runWorkflow:
      run:
        workflow:
          namespace: another-one
          name: do-stuff
          version: '0.1.0'
          input: {}
        return: none
```

### AsyncAPI Server

Configures the target server of an AsyncAPI operation.

#### Properties

| Name | Type | Required | Description |
|:-----|:----:|:--------:|:------------|
| name | `string` | `yes` | The name of the [server](https://www.asyncapi.com/docs/reference/specification/v3.0.0#serverObject) to call the specified AsyncAPI operation on. |
| variables | `object` | `no` | The target [server's variables](https://www.asyncapi.com/docs/reference/specification/v3.0.0#serverVariableObject), if any. |

#### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: asyncapi-example
  version: '0.1.0'
do:
  - publishGreetings:
      call: asyncapi
      with:
        document:
          endpoint: https://fake.com/docs/asyncapi.json
        operation: greet
        server:
          name: greetingsServer
          variables:
            environment:  dev
        message:
          payload:
            greetings: Hello, World!
          headers:
            foo: bar
            bar: baz
```

### AsyncAPI Outbound Message

Configures an AsyncAPI message to publish.

#### Properties

| Name | Type | Required | Description |
|:-----|:----:|:--------:|:------------|
| payload | `object` | `no` | The message's payload, if any. |
| headers | `object` | `no` | The message's headers, if any. |

#### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: asyncapi-example
  version: '0.1.0'
do:
  - publishGreetings:
      call: asyncapi
      with:
        document:
          endpoint: https://fake.com/docs/asyncapi.json
        operation: greet
        protocol: http
        message:
          payload:
            greetings: Hello, World!
          headers:
            foo: bar
            bar: baz
```

### AsyncAPI Inbound Message

Configures an AsyncAPI message consumed by a subscription.

#### Properties

| Name | Type | Required | Description |
|:-------|:------:|:----------:|:--------------|
| payload | `object` | `no` | The message's payload, if any. |
| headers | `object` | `no` | The message's headers, if any. |
| correlationId | `string` | `no` | The message's correlation id, if any. |

#### Examples

```yaml
payload:
  greetings: Hello, World!
headers:
  foo: bar
  bar: baz
correlationid: '123456'
```

### AsyncAPI Subscription

Configures a subscription to an AsyncAPI operation.

#### Properties

| Name | Type | Required | Description |
|:-------|:------:|:----------:|:--------------|
| filter | `string` | `no` | A [runtime expression](dsl.md#runtime-expressions), if any, used to filter consumed [messages](#asyncapi-inbound-message). |
| consume | [`subscriptionLifetime`](#asyncapi-subscription-lifetime) | `yes` | An object used to configure the subscription's lifetime. |
| foreach | [`subscriptionIterator`](#subscription-iterator) | `no` | Configures the iterator, if any, for processing each consumed [message](#asyncapi-inbound-message). |

> [!NOTE]
> An AsyncAPI subscribe operation call produces a sequentially ordered array of all the [messages](#asyncapi-inbound-message) it has consumed, and potentially transformed using `foreach.output.as`.

> [!NOTE]
> When `foreach` is set, the configured operations for a [message](#asyncapi-inbound-message) must complete before moving on to the next one. As a result, consumed [messages](#asyncapi-inbound-message) should be stored in a First-In-First-Out (FIFO) queue while awaiting iteration.

#### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: asyncapi-example
  version: '0.1.0'
do:
  - subscribeToChatInboxForAmount:
      call: asyncapi
      with:
        document:
          endpoint: https://fake.com/docs/asyncapi.json
        operation: chat-inbox
        protocol: http
        subscription:
          filter: ${ . == $workflow.input.chat.roomId } 
          consume:
            amount: 5
            for:
              seconds: 10
```

### AsyncAPI Subscription Lifetime

Configures the lifetime of an AsyncAPI subscription

#### Properties

| Name | Type | Required | Description |
|:-----|:----:|:--------:|:------------|
| amount | `integer` | `no` | The amount of messages to consume.<br>*Required if `while` and `until` have not been set.* |
| for | [`duration`](#duration) | `no` | The [`duration`](#duration) that defines for how long to consume messages. |
| while | `string` | `no` | A [runtime expression](dsl.md#runtime-expressions), if any, used to determine whether or not to keep consuming messages.<br>*Required if `amount` and `until` have not been set.* |
| until | `string` | `no` | A [runtime expression](dsl.md#runtime-expressions), if any, used to determine until when to consume messages.<br>*Required if `amount` and `while` have not been set.* |

#### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: asyncapi-example
  version: '0.1.0'
do:
  - subscribeToChatInboxUntil:
      call: asyncapi
      with:
        document:
          endpoint: https://fake.com/docs/asyncapi.json
        operation: chat-inbox
        protocol: http
        subscription:
          filter: ${ . == $workflow.input.chat.roomId } 
          consume:
            until: '${ ($context.messages | length) == 5 }'
            for:
              seconds: 10
```

### Subscription Iterator

Configures the iteration over each item (event or message) consumed by a subscription. It encapsulates configuration for processing tasks, output formatting, and export behavior for every item encountered.

#### Properties

| Name | Type | Required | Description |
|:-----|:----:|:--------:|:------------|
| item | `string` | `no` | The name of the variable used to store the current item being enumerated.<br>*Defaults to `item`.* |
| at | `string` | `no` | The name of the variable used to store the index of the current item being enumerated.<br>*Defaults to `index`.* |
| do | [`map[string, task]`](#task) | `no` | The tasks to perform for each consumed item. |
| output | [`output`](#output) | `no` | An object, if any, used to customize the item's output and to document its schema. |
| export | [`export`](#export) | `no` | An object, if any, used to customize the content of the workflow context. |

#### Examples

```yaml
document:
  dsl: '1.0.3'
  namespace: test
  name: asyncapi-example
  version: '0.1.0'
do:
  - subscribeToChatInboxUntil:
      call: asyncapi
      with:
        document:
          endpoint: https://fake.com/docs/asyncapi.json
        operation: chat-inbox
        protocol: http
        subscription:
          filter: ${ . == $workflow.input.chat.roomId } 
          consume:
            until: '${ ($context.messages | length) == 5 }'
            for:
              seconds: 10
          foreach:
            item: message
            at: index
            do:
              - emitEvent:
                  emit:
                    event:
                      with:
                        source: https://serverlessworkflow.io/samples
                        type: io.serverlessworkflow.samples.asyncapi.message.consumed.v1
                        data:
                          message: '${ $message }'
```

### Workflow Definition Reference

References a workflow definition.
                                  
#### Properties

| Name | Type | Required | Description |
|:-----|:----:|:--------:|:------------|
| name | `string` | `yes` | The name of the referenced workflow definition. |
| namespace | `string` | `yes` | The namespace of the referenced workflow definition. |
| version | `string` | `yes` | The semantic version of the referenced workflow definition. |
                                  
#### Examples

```yaml
name: greet
namespace: samples
version: '0.1.0-rc2'
```

### MCP Transport

Defines the transport to use for a [Model Context Protocol (MCP)](https://modelcontextprotocol.io/) call.

#### Properties

| Name | Type | Required | Description |
|:-----|:----:|:--------:|:------------|
| http | [`mcpHttpTransport`](#mcp-http-transport) | `no` | The definition of the HTTP transport to use.<br>*Required if `stdio` has not been set.* |
| stdio | [`mcpStdioTransport`](#mcp-stdio-transport) | `no` |  The definition of the STDIO transport to use.<br>*Required if `http` has not been set.* |
| options | `map[string, string]` | `no` | A key/value mapping containing additional transport-specific configuration options, if any. |

### MCP HTTP Transport

Defines a [Model Context Protocol (MCP)](https://modelcontextprotocol.io/) HTTP transport.

#### Properties

| Name | Type | Required | Description |
|:-----|:----:|:--------:|:------------|
| endpoint | `string`<br>[`endpoint`](#endpoint) | `yes` | An URI or an object that references the MCP server endpoint to connect to.<br>*Supports [runtime expressions](dsl.md#runtime-expressions).* |
| headers | `map[string, string]` | `no` | A key/value mapping of the HTTP headers to send with requests, if any. |

#### Examples

```yaml
transport:
  http:
    endpoint: https://mcp.contoso.com
    headers:
      authorization: Bearer 8AE4SZgJX8tw40oJJq7VJt1plKnVnH8I
```

### MCP STDIO Transport

Defines a [Model Context Protocol (MCP)](https://modelcontextprotocol.io/) STDIO transport.

#### Properties

| Name | Type | Required | Description |
|:-----|:----:|:--------:|:------------|
| command | `string` | `yes` | The command used to run the MCP server.<br>*Supports [runtime expressions](dsl.md#runtime-expressions).* |
| arguments | `string[]` | `no` | An optional list of arguments to pass to the command. |
| environment | `map[sttring, string]` | `no` | A key/value mapping, if any, of environment variables used to configure the MCP server. |

#### Examples

```yaml
transport:
  stdio:
    command: uvx  
    arguments: [ mcp-server-fetch ]
```

### MCP Client

Describes the client of a [Model Context Protocol (MCP)](https://modelcontextprotocol.io/) call.

#### Properties

| Name | Type | Required | Description |
|:-----|:----:|:--------:|:------------|
| name | `string` | `yes` | The name of the client used to connect to the MCP server. |
| version | `string` | `yes` | The version of the client used to connect to the MCP server. |

#### Examples

```yaml
name: synapse
version: '1.0.0-alpha5.2'
```
