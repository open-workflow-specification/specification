# Contributing to Open Workflow Specification

This page contains information about reporting issues, how to suggest changes as
well as the guidelines we follow for how our documents are formatted.

## Table of Contents

- [Reporting an Issue](#reporting-an-issue)
- [Suggesting a Change](#suggesting-a-change)
- [Versioning](#versioning)
- [Spec Formatting Conventions](#spec-formatting-conventions)

## Reporting an Issue

If you have a question, consider opening a
[discussion](https://github.com/serverlessworkflow/specification/discussions).

To report an issue or to suggest an idea for a change that you haven't had time
to write up yet, open an
[issue](https://github.com/serverlessworkflow/specification/issues). It is best
to check our existing
[issues](https://github.com/serverlessworkflow/specification/issues) first to
see if a similar one has already been opened and discussed.

## Suggesting a Change

Enhancements or bugs in a specification are not always easy to describe at first
glance, requiring some discussions with other contributors before reaching a
conclusion.

Before opening a pull request, we kindly ask you to consider opening a
[discussion](https://github.com/serverlessworkflow/specification/discussions)
or an [issue](https://github.com/serverlessworkflow/specification/issues). The
community will be more than happy to discuss your proposals there.

Having the discussion or issue settled, please submit a
[pull request](https://github.com/serverlessworkflow/specification/pulls) (PR)
with the complete set of changes discussed with the community. See the
[Spec Formatting Conventions](#spec-formatting-conventions) section for the
guidelines we follow for how documents are formatted.

Each PR must be signed per the following section and have a link to the issue or
discussion.

### Fixing Typos, Spelling, and Formatting issues

Due to the amount of text a specification can have, typos, spelling, and
formatting issues are pretty common. In these cases, please submit a
[pull request](https://github.com/serverlessworkflow/specification/pulls)
directly only with the fixes that you see fit.

### Assigning and Owning work

If you want to own and work on an issue, add a comment or “#dibs” it asking
about ownership. A maintainer will then add the Assigned label and modify the
first comment in the issue to include `Assigned to: @person`

## Versioning

The versioning strategy for the Open Workflow DSL is structured to accommodate different types of changes introduced through pull requests (PRs). 

If a PR is labeled with `change: documentation`, indicating modifications related to improving or clarifying documentation, it does not trigger a version change. 

Conversely, if the PR addresses a fix, labeled as `change: fix`, it results in an increase in the patch version (0.0.x). 
A fix typically refers to corrections made to resolve bugs or errors in the DSL specification or its implementations, ensuring smoother functionality and reliability. 

Similarly, when a PR introduces a new feature, labeled as `change: feature`, it prompts an increase in the minor version (0.x.0). 
A feature denotes the addition of significant capabilities, enhancements, or functionalities that extend the DSL's capabilities or improve its usability. 

Lastly, if the PR is marked as `change: breaking`, indicating alterations that are incompatible with previous versions, it leads to an increase in the major version (x.0.0). A breaking change signifies modifications that necessitate adjustments in existing workflows or implementations, potentially impacting backward compatibility. 

This versioning strategy ensures clarity and transparency in tracking changes and communicating their impact on users and implementations.

| Label | Version Change |  Description  |
|:-- |:---:|:---|
| `change: documentation` | - | Modifications related to documentation improvements or clarifications. |
| `change: fix` | `0.0.x` | Corrections made to resolve bugs or errors in the DSL specification or its implementations. |
| `change: feature` | `0.x.0` | Addition of significant capabilities, enhancements, or functionalities that extend the DSL's capabilities or improve its usability. |
| `change: breaking` | `x.0.0` | Alterations that are incompatible with previous versions, necessitating adjustments in existing workflows or implementations. |

In addition to versioning changes denoted by labels in pull requests, pre-release versions will be suffixed with either `alphaX`, `betaX`, or `rcX` where `X` represents the pre-release version number (ex: `1.0.0-alpha1`). These pre-release versions are designated to indicate different stages of development and testing before the final release.

- **Alpha versions** are the earliest stages of testing and development. They typically contain incomplete features and may have known issues. They are intended for a limited audience, such as internal testers or early adopters, for initial feedback and testing.

- **Beta versions** represent a more stable state compared to alpha versions. They are released to a broader audience, allowing for wider testing and feedback collection. Beta versions may still contain bugs or issues, but they are generally considered to be closer to the final release state.

- **Release Candidate (RC)** versions are the versions that are considered to be potentially ready for final release. They undergo rigorous testing to identify and resolve any remaining critical issues. RC versions are released to a wider audience for final validation before the official release.

These pre-release versions with appropriate suffixes provide transparency about the development stage and help users and testers understand the level of stability and readiness of each release candidate.

## Spec Formatting Conventions

Documents in this repository will adhere to the following rules:

- Lines are wrapped at 80 columns (when possible)
- Specifications will use [RFC2119](https://tools.ietf.org/html/rfc2119)
  keywords to indicate normative requirements

## Checks

### Markdown style

Markdown files should be appropriately formatted before a pull request is sent out.
In this repository, we follow the
[markdownlint rules](https://github.com/DavidAnson/markdownlint#rules--aliases)
with some customizations. See [markdownlint](.markdownlint.yaml) or
[settings](.vscode/settings.json) for details.

We highly encourage using line breaks in markdown files at `80` characters
wide. Some tools can do it for you effectively. Please submit the proposal
to include your editor settings required to enable this behavior so the
out-of-the-box settings for this repository will be consistent.

If you are using Visual Studio Code,
you can also use the `fixAll` command of the
[vscode markdownlint extension](https://github.com/DavidAnson/vscode-markdownlint).

To otherwise check for style violations, use:

```bash
# Ruby and gem are required for mdl
gem install mdl
mdl -c .mdlrc .
```

To fix style violations, follow the
[instruction](https://github.com/DavidAnson/markdownlint#optionsresultversion)
with the Node version of markdownlint.

### Typos

In addition, please make sure to clean up typos before you submit the change.

To check for typos, you may use

```bash
# Golang is needed for the misspell tool.
make install-misspell
make misspell
```

To quickly fix typos, use:

```bash
make misspell-correction
```
