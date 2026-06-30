# Security Policy

## Reporting a Vulnerability

The Open Workflow Specification team and community take security bugs very seriously. We appreciate your efforts to responsibly disclose your findings, and will make every effort to acknowledge your contributions.

To report a security issue, please use the GitHub Security Advisory ["Report a Vulnerability"](https://github.com/serverlessworkflow/specification/security/advisories/new) tab.

The Open Workflow Specification team will send a response indicating the next steps in handling your report. After the initial reply to your report, the security team will keep you informed of the progress towards a fix and full announcement, and may ask for additional information or guidance.

## Security Best Practices

To help ensure the security of your workflows, we recommend the following best practices:

- **Keep Up to Date**: Always use the latest version of the Open Workflow DSL.
- **Review Code**: Regularly review your workflows and code for potential security issues.
- **Access Control**: Implement proper access controls to restrict who can create, modify, or execute workflows.
- **Monitor and Audit**: Continuously monitor and audit workflows to detect and respond to any suspicious activities.
- **Secure External Resources**: Ensure that any resources external to a workflow definition are always secured using modern authentication policies as defined in the DSL.
- **Use Trusted Containers and Scripts**: When relying on [run tasks](dsl-reference.md#run), only use trusted container images, scripts, commands and workflows.
- **Custom Functions**: Only use custom functions from the [Open Workflow Catalog](https://github.com/serverlessworkflow/catalog) or from trusted sources to avoid introducing vulnerabilities.
  
---

Thank you for helping to keep the Open Workflow Specification secure!
