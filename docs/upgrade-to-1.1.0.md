# Upgrading from 1.0.1 to 1.1.0

This guide lists every change between `v1.0.1` (the last non-pre-release) and `v1.1.0`. The `v1.0.2` and `v1.0.3` tags were pre-releases, so they are folded in here.

- [Who is affected](#who-is-affected)
- [Breaking changes](#breaking-changes)
- [Deprecations and renames](#deprecations-and-renames)
- [Behavioral changes for runtimes](#behavioral-changes-for-runtimes)
- [Additions](#additions)
- [Documentation corrections](#documentation-corrections)
- [Upgrade checklists](#upgrade-checklists)

## Who is affected

| Audience | What to do |
|:---------|:-----------|
| Workflow authors | Review [Breaking changes](#breaking-changes) marked **Author** and the [Deprecations and renames](#deprecations-and-renames). Then set `document.dsl: '1.1.0'` to use new features. Existing `1.0.x` workflows stay valid unless they hit one of those items. |
| Runtime implementers | Review all items marked **Runtime**, plus [Deprecations and renames](#deprecations-and-renames) and [Behavioral changes for runtimes](#behavioral-changes-for-runtimes). |
| SDK / tooling maintainers | Review items marked **Tooling**: the JSON schema file, the schema `$id`, and renamed schema titles. |
| Event consumers | Review the [event type namespace deprecation](#deprecations-and-renames) and the lifecycle event `outputUri` change. |

## Breaking changes

| # | Change | Affects | From (1.0.1) | To (1.1.0) | Ref |
|:-:|:-------|:--------|:-------------|:-----------|:----|
| 1 | `run.shell.arguments` type | Author, Runtime, Tooling | `map` (`object`) | `string[]`, passed as `argv` | #1129, #1195 |
| 2 | Lifecycle completed events | Runtime, Event consumers | `output` (map) in `workflow.completed` and `task.completed` | `outputUri` (URI, claim-check pattern) | #1151 |
| 3 | Schema file and `$id` | Tooling | `schema/workflow.json` and `workflow.yaml`, `$id` `https://serverlessworkflow.io/schemas/1.0.1/workflow.{json,yaml}` | YAML only. `schema/workflow.json` is removed. `$id` is `https://open-workflow-specification.org/schemas/1.1.0/workflow.yaml` | #1099, #1127 |
| 4 | `catch.errors.with` filter property | Author, Runtime | `details` | `detail` (matches RFC 7807) | #1161 |
| 5 | Inline OAuth2 authentication | Author | `authority` and `grant` optional | `authority` and `grant` **required** | #1161 |
| 6 | Reserved `call` names | Author | `call` function names that are not `asyncapi`, `grpc`, `http`, `openapi` are custom functions | `a2a` and `mcp` are also reserved and cannot name a custom function | #1101, #1102 |
| 7 | Schema `title` fixes | Tooling | `OAuth2Autenthication*`, `WithGRPCServicePost` | `OAuth2Authentication*`, `WithGRPCServicePort` | #1112, #1115 |
| 8 | URI field validation | Author, Tooling | `uriTemplate` required `scheme://...`. `LiteralUri` used `format: uri` | RFC 3986 URI-references accepted (relative references allowed). `LiteralUri` uses `format: uri-reference`. `LiteralUriTemplate` must contain a `{...}` expression. `LiteralUri` must not contain `{` or `}`. Both reject values that start with `${` | #1166, #1183 |

### Migration details

#### 1. `run.shell.arguments`

```yaml
# 1.0.1
run:
  shell:
    command: echo
    arguments:
      first: Foo
      second: Bar

# 1.1.0
run:
  shell:
    command: echo
    arguments:
      - Foo
      - Bar
```

`run.script.arguments` is **unchanged** from 1.0.1 and remains a map. It was briefly an array in the `1.0.2` and `1.0.3` pre-releases and was reverted (#1180, #1201). If you followed the pre-releases, switch back to a map.

#### 2. Lifecycle `outputUri`

Events larger than 64 KiB are not guaranteed to be delivered, so the output is no longer embedded. Producers publish a URI to the data, and consumers dereference it.

```yaml
# 1.0.1
output:
  orderId: '0a7f8581-acb9-4133-a378-0460c98ea60c'
  status: placed

# 1.1.0
outputUri: https://workflow-engine.example.com/workflows/orderPetWorkflow-ix7iryakiem8j/output
```

#### 3. Schema distribution

Point validators at `schema/workflow.yaml`. Update any hard-coded `$id` or `$ref` to the new `$id`.

#### 5. Inline OAuth2

Definitions that relied on the schema being permissive (no `authority` or `grant`) now fail validation. They were never meaningful, since an OAuth2 policy needs both.

#### 8. URI validation

Existing absolute URIs remain valid. Review any workflow that depended on a string being rejected for lacking `scheme://`.

## Deprecations and renames

These come from the project rename (#1127). They are **not breaking in 1.x**: nothing has to change to keep running on 1.1.0. The old identifiers are deprecated and **will be removed in 2.0.0**.

| Identifier | Deprecated (1.0.1) | Replacement (1.1.0) | Status in 1.x | Ref |
|:-----------|:-------------------|:--------------------|:--------------|:----|
| Event type namespace | `io.serverlessworkflow.*` | `org.open-workflow-specification.*` | Runtimes **MUST** support both. Removed in 2.0.0 | #1127 |
| Standard error type URI host | `https://serverlessworkflow.io/spec/1.0.0/errors/*` | `https://open-workflow-specification.org/spec/1.0.0/errors/*` | Deprecated. Removed in 2.0.0 | #1127, #1188 |

> [!NOTE]
> The old event namespace and the old error type host **will be removed in 2.0.0**. Migrate to the new identifiers during 1.x.

**Event type namespace.** All lifecycle event types move to the new namespace, for example `io.serverlessworkflow.workflow.started.v1` becomes `org.open-workflow-specification.workflow.started.v1`. The specification requires runtimes to support both namespaces throughout 1.x and allows them to drop the old one in 2.0. Producers should emit the new namespace. Consumers should subscribe to both until all producers have upgraded.

**Error type URIs.** The host changed. The `/spec/1.0.0/` path segment is intentionally unchanged. Runtimes should raise the standard errors with the new host. Workflows that filter on `catch.errors.with.type` should use the new host. The specification does not currently require runtimes to match the old host in 1.x, so check how your runtime handles workflows that still filter on it. Custom, user-defined error types are not affected.

## Behavioral changes for runtimes

These do not change the schema but change what a conforming runtime must do.

| Change | Requirement | Ref |
|:-------|:------------|:----|
| jq output stream mapping | A single emitted value is returned as-is. Multiple values become an array in emission order. No value (`empty`) becomes `null`. An error after emitted values fails the expression. Runtimes must not apply `first(...)` implicitly | #1181 |
| No evaluation of input data | Runtimes **MUST** evaluate only expressions defined in the workflow, and **MUST NOT** evaluate expression syntax found in workflow or task input data | #1162 |
| Event `id` and `source` generation | `emit.event.with` requires only `type`. Runtimes generate `id` (for example a UUID) and `source` (for example from the workflow identity) at emission time. An author-supplied value takes precedence | #1167, #1174 |
| Shell task governance | Runtimes that support `run.shell` **MUST** document the commands and platforms they support, and **SHOULD** apply constraints such as allow-listing or sandboxing. Authors **SHOULD** avoid shell tasks when portability matters | #1194 |
| A2A defaults | For `message/send` and `message/stream`, runtimes default `message.messageId` to a UUID and `message.role` to `user` | #1102 |
| MCP initialization | Runtimes **must** send `initialize` before any other MCP request | #1101 |
| `try.catch.then` | When set, it determines the next transition after the error is caught (and after any `catch.do` tasks), overriding the try task's `then` and the default sequential flow | #1148 |
| Status code and headers | `statusCode` is the numeric status from the HTTP/1.1 status line or the HTTP/2 and HTTP/3 `:status` field. With `output: response`, `.headers`, `.statusCode` and `.content` are available in `output.as` and `export.as` | #1203 |
| CTK | New `expression.feature`. Extended `call.feature` (HTTP response output). `try` and `raise` features use the mandated communication error type | #1181, #1203, #1200 |

## Additions

All of these are backward compatible. Use them by setting `document.dsl: '1.1.0'`.

| Addition | Detail | Ref |
|:---------|:-------|:----|
| `call: mcp` | Calls Model Context Protocol servers (`http` or `stdio` transport, optional `client`) | #1101 |
| `call: a2a` | Calls A2A agents (`agentCard` or `server`) | #1102 |
| `run.container`: `stdin`, `arguments`, `pullPolicy` | `pullPolicy` is `ifNotPresent` (default), `always` or `never` | #1129, #1138 |
| `run.script.stdin` | Runtime expression piped to the script | #1129 |
| `run.shell.stdin`, `run.shell.directory` | Standard input and working directory | #1129, #1191 |
| `schedule.on.read` | `data` (default), `envelope` or `raw`. Requires `schedule.on` | #1177 |
| `evaluate` (`language`, `mode`) | Now part of the schema. Both are optional (`jq` and `strict` by default) | #1160 |
| `for.in` inline array | An array literal in addition to a runtime expression. Any item type | #1163, #1186 |
| `try.catch.then` | Flow directive for the error path | #1148 |
| Duration as a runtime expression | `duration` accepts an expression that evaluates to an ISO 8601 string | #1119 |
| gRPC hosts with dots | `grpc.service.host` accepts `.` | #1111 |
| Event `source` auto-generation | See [Behavioral changes](#behavioral-changes-for-runtimes) | #1174 |

## Documentation corrections

The schema already behaved this way in 1.0.1. The reference documentation was wrong and now matches the schema. No action is needed unless your tooling followed the old text.

| Area | Correction | Ref |
|:-----|:-----------|:----|
| `do` | Documented as required | #1156, #1179 |
| `use.extensions` | `extension[]`, not `map[string, extension]` | #1136, #1161 |
| `extend` values | The nonexistent `extension` value is removed | #1161 |
| `extension.before` / `after` | `task[]`, not a map | #1136 |
| `evaluate.language` / `mode` | Optional, not required | #1160 |
| AsyncAPI call | `channel` and `operation` are optional. Exactly one must be set, paired with `message` or `subscription` | #1161 |
| `run.workflow.namespace` | Documented as required | #1161 |
| Duration properties | Lower-case (`days`, `hours`, `minutes`, `seconds`, `milliseconds`) | #1161 |
| OAuth2 / OIDC `issuers` | `string[]`, not `uri-template[]` | #1161 |
| `retry.delay` | Documented | #1142 |
| Certificate authentication | The section is removed. It was documented but never in the schema | #1160 |
| Task `if` input | Evaluated against the **raw** task input | #1140 |
| Custom function example | `language: js` and `endpoint:` instead of `javascript` and `uri:` | #1136, #1161 |
| Examples and samples | Event type namespace and catalog links updated to the new organization | #1127, #1165 |

## Upgrade checklists

### Workflow authors

- [ ] Convert `run.shell.arguments` from a map to a list.
- [ ] Rename `details` to `detail` in `catch.errors.with`.
- [ ] Add `authority` and `grant` to any inline OAuth2 definition that lacks them.
- [ ] Update filters on standard error `type` URIs to the new host. The old host is removed in 2.0.0.
- [ ] Rename custom functions called `a2a` or `mcp`.
- [ ] Update event `type` values that use `io.serverlessworkflow.*`. The old namespace is removed in 2.0.0.
- [ ] Set `document.dsl: '1.1.0'`.

### Runtime implementers

- [ ] Emit lifecycle events with the new namespace and keep accepting the old one through 1.x. The old namespace is removed in 2.0.0.
- [ ] Replace `output` with `outputUri` in the completed lifecycle events.
- [ ] Raise standard errors with the new type URI host. The old host is removed in 2.0.0.
- [ ] Implement the jq output stream mapping.
- [ ] Generate `id` and `source` for `emit` when absent.
- [ ] Accept `run.shell.arguments` as a list.
- [ ] Document supported shell commands and platforms.
- [ ] Re-run the CTK, including the new `expression.feature`.

### SDK and tooling maintainers

- [ ] Stop consuming `schema/workflow.json`. Generate from `schema/workflow.yaml`.
- [ ] Update the schema `$id` to `https://open-workflow-specification.org/schemas/1.1.0/workflow.yaml`.
- [ ] Regenerate models: `OAuth2Authentication*` and `WithGRPCServicePort` are renamed, and new types are added for `mcp`, `a2a`, `evaluate`, `schedule.on.read` and `for.in`.
- [ ] Accept `document.dsl` values of `1.0.x` and `1.1.0`.
