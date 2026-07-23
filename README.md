[![contributions Welcome](https://img.shields.io/badge/Contributions-Welcome-green.svg?style=flat)](https://github.com/serverlessworkflow/specification/issues)
[![license](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/serverlessworkflow/specification/blob/master/LICENSE)
[<img alt="GitHub Release" src="https://img.shields.io/github/v/release/serverlessworkflow/specification?label=Release">](https://github.com/serverlessworkflow/specification/releases/latest)
<br>
[<img src="http://img.shields.io/badge/Website-blue?style=flat&logo=google-chrome&logoColor=white">](https://open-workflow-specification.org/) 
[<img src="http://img.shields.io/badge/Slack-4A154B?style=flat&logo=slack&logoColor=white">](https://cloud-native.slack.com/messages/open-workflow) 
[<img src="https://img.shields.io/badge/LinkedIn-blue?logo=linkedin&logoColor=white">](https://www.linkedin.com/company/serverless-workflow/)
[<img src="https://img.shields.io/twitter/follow/CNCFWorkflow?style=social">](https://twitter.com/CNCFWorkflow)

## Table of Contents

- [About](#about)
- [Ecosystem](#ecosystem)
  + [DSL](dsl.md)
  + [CTK](/ctk/README.md)
  + [SDKs](#sdks)
  + [Runtimes](#runtimes)
  + [Tooling](#Tooling)
  + [Landscape](#cncf-landscape)
- [Documentation](#documentation)
- [Community](#community)
  + [Communication](#communication)
  + [Governance](#governance)
  + [Code of Conduct](#code-of-conduct)
  + [Weekly Meetings](#weekly-meetings)
+ [Support](#support)
  - [Adoption](#adoption)
  - [Sponsoring](#sponsoring)

## About

Open Workflow Specification presents a vendor-neutral, open-source, and entirely community-driven ecosystem for defining and executing DSL-based workflows. 

The Open Workflow DSL is a high-level language that reshapes the terrain of workflow creation, boasting a design that is ubiquitous, intuitive, imperative, and fluent. 

Bid farewell to convoluted coding and platform dependencies—now, crafting powerful workflows is effortlessly within reach for everyone!

Key features:

- **Easy to Use**: Designed for universal understanding, Open Workflow DSL enables users to quickly grasp workflow concepts and create complex workflows effortlessly.
- **Event Driven**: Seamlessly integrate events into workflows with support for various formats, including CloudEvents, allowing for event-driven workflow architectures.
- **Service Oriented**: The Open Workflow DSL empowers developers to seamlessly integrate with service-oriented architectures, allowing them to define workflows that interact with various services over standard application protocols like HTTP, GRPC, OpenAPI, AsyncAPI, and more.
- **FaaS Centric**: Seamlessly invoke functions hosted on various platforms within workflows, promoting a function-as-a-service (FaaS) paradigm and enabling microservices architectures.
- **Timely**: Define timeouts for workflows and tasks to manage execution duration effectively.
- **Fault Tolerant**: Easily define error handling strategies to manage and recover from errors that may occur during workflow execution, ensuring robustness and reliability.
- **Schedulable**: Schedule workflows using CRON expressions or trigger them based on events, providing control over workflow execution timing.
- **Interoperable**: Integrates seamlessly with different services and resources.
- **Robust**: Offers features such as conditional branching, event handling, and looping constructs.
- **Scalable**: Promotes code reusability, maintainability, and scalability across different environments.

## Ecosystem

Open Workflow Specification ecosystem is hosted by the [Cloud Native Computing Foundation (CNCF)](https://www.cncf.io/) and was approved as a
Cloud Native Sandbox level project on July 14, 2020.

It encompasses a comprehensive suite of components and tools designed to facilitate the creation, management, and execution of workflows. 

1. **[DSL](dsl.md) (Domain Specific Language)**: The core of the ecosystem, defining the fundamental syntax and semantics of the Open Workflow Specification.

2. **[CTK](/ctk/README.md) (Conformance Test Kit)**: A set of Gherkin features utilized for both conformance testing and Behavior Driven Design (BDD), ensuring compliance and facilitating testing across implementations.

3. **[SDKs](#sdks) (Software Development Kits)**: These enable developers to interact with workflows in various programming languages, providing functionalities such as reading, writing, building, and validating workflows.

4. **[Runtimes](#runtimes)**: Dedicated environments for executing workflows defined using the Open Workflow DSL, ensuring seamless deployment and operation within diverse runtime environments.

5. **[Tooling](#tooling)**: Additional utilities and resources tailored to enhance the development, debugging, and management of workflows, streamlining the workflow lifecycle from creation to deployment and maintenance.

### SDKs

The Open Workflow Specification SDKs are essential tools designed to assist developers in consuming, parsing, validating, and testing their workflows utilizing the Open Workflow DSL.

These SDKs empower developers to seamlessly integrate workflows into their applications, providing robust support for various programming languages. By offering comprehensive functionality, they streamline the development process and enhance workflow management.

Explore our SDKs for different programming languages:

- [.NET](https://github.com/serverlessworkflow/sdk-net)
- [Go](https://github.com/serverlessworkflow/sdk-go)
- [Java](https://github.com/serverlessworkflow/sdk-java)
- [PHP](https://github.com/serverlessworkflow/sdk-php)
- [Python](https://github.com/serverlessworkflow/sdk-python)
- [Rust](https://github.com/serverlessworkflow/sdk-rust)
- [TypeScript](https://github.com/serverlessworkflow/sdk-typescript)

Don't see your favorite implementation on the list? Shout out to the community about it or, even better, contribute to the ecosystem with a new SDK!

No matter your preferred language, our SDKs provide the tools you need to leverage the power of serverless workflows effectively.

### Runtimes

| Name | About |
| --- | --- |
| [Apache KIE SonataFlow](https://sonataflow.org) | Apache KIE SonataFlow is a tool for building cloud-native workflow applications. You can use it to do the services and events orchestration and choreography. |
| [Java SDK reference implementation](https://github.com/serverlessworkflow/sdk-java/tree/main/impl) | Full compliant Java implementation of the specification |
| [Lemline](https://github.com/lemline/lemline) | Lemline is a highly scalable runtime running on top of your existing messaging infrastructure. |
| [Synapse](https://github.com/serverlessworkflow/synapse) | Synapse is a scalable, cross-platform, fully customizable platform for managing and running workflows defined with Open Workflow Specification. |

### Tooling

In order to enhance developer experience with the Open Workflow DSL, we provide a [Visual Studio Code extension](https://marketplace.visualstudio.com/items?itemName=serverlessworkflow.serverless-workflow-vscode-extension).

The sources of the extension can be found [here](https://github.com/serverlessworkflow/vscode-extension).

### CNCF Landscape

Open Workflow Specification project falls under the [CNCF "App Definition and Development"](https://landscape.cncf.io/card-mode?category=app-definition-and-development&grouping=category) category.

It is a member project of the [CNCF Serverless Working Group](https://github.com/cncf/wg-serverless).

<p align="center">
<a href="https://landscape.cncf.io/?category=application-definition-image-build&grouping=category" target="_blank"><img src="media/landscape/cncf-landscape.png" width="700px" alt="CNCF Landscape"/></a>
</p>

## Documentation

The documentation for Open Workflow Specification includes:

- [**DSL**](dsl.md): Documents the fundamentals aspects and concepts of the Open Workflow DSL.
- [**DSL Reference**](dsl-reference.md): References all the definitions used by the Open Workflow DSL.
- [**Comparison**](comparison.md): See how Open Workflow Specification compares to other DSLs.
- [**Examples**](./examples/README.md): A collection of practical examples demonstrating specific features and functionalities of Open Workflow Specification.
- [**Use Cases**](./use-cases/README.md): Detailed use cases illustrating how Open Workflow Specification can be applied in various real-world scenarios.

## Community

We have a growing community working together to build a community-driven and vendor-neutral
workflow ecosystem. Community contributions are welcome and much needed to foster project growth.

See [here](community/contributors.md) for the list of community members that have contributed to the specification.

To learn how to contribute to the specification please refer to ['how to contribute'](contributing.md).

If you have any copyright questions when contributing to a CNCF project like this one,
reference the [Ownership of Copyrights in CNCF Project Contributions](https://github.com/cncf/foundation/blob/master/copyright-notices.md).
  
### Communication

- Community Slack Channel: [https://slack.cncf.io/](https://slack.cncf.io/) -  #open-workflow
- [Weekly project meetings](#weekly-meetings)
- Project Maintainers Email: [cncf-serverlessws-maintainers](mailto:cncf-serverlessws-maintainers@lists.cncf.io)
- Serverless WG Email: [cncf-wg-serverless](mailto:cncf-wg-serverless@lists.cncf.io)
- Serverless WG Subscription: [https://lists.cncf.io/g/cncf-wg-serverless](https://lists.cncf.io/g/cncf-wg-serverless)

### Governance

The Open Workflow Specification Project Governance [document](GOVERNANCE.md) delineates the roles, procedures, and principles guiding the collaborative development and maintenance of the project. 

It emphasizes adherence to the CNCF Code of Conduct, defines the responsibilities of maintainers, reviewers, and emeritus maintainers, outlines procedures for their addition and removal, and establishes guidelines for subprojects' inclusion and compliance.

Decision-making processes are consensus-driven, facilitated through structured proposal and discussion mechanisms, with conflict resolution procedures prioritizing amicable resolution. 

Overall, the document reflects the project's commitment to transparency, accountability, and inclusive collaboration, fostering an environment conducive to sustained growth and innovation.

See the project's Governance Model [here](GOVERNANCE.md).

### Code of Conduct

As contributors and maintainers of this project, and in the interest of fostering
an open and welcoming community, we pledge to respect all people who contribute
through reporting issues, posting feature requests, updating documentation,
submitting pull requests or patches, and other activities.

We are committed to making participation in this project a harassment-free experience for
everyone, regardless of level of experience, gender, gender identity and expression,
sexual orientation, disability, personal appearance, body size, race, ethnicity, age,
religion, or nationality.

See the project's Code of Conduct [here](code-of-conduct.md).

### Weekly Meetings

The Open Workflow Specification team meets weekly, every Thursday at 9AM ET (USA Eastern Time).

To register for meetings please visit the [CNCF Community Calendar](https://tockify.com/cncf.public.events/monthly?search=open%20workflow).

You can register for individual meetings or for the entire series.

## Support

### Adoption

If you're using Open Workflow Specification in your projects and would like to showcase your adoption, become an Adopter! By joining our community of adopters, you'll have the opportunity to share your experiences, contribute feedback, and collaborate with like-minded individuals and organizations leveraging Open Workflow Specification to power their workflows.

### Sponsoring

As an open-source project, Open Workflow Specification relies on the support of sponsors to sustain its development and growth. 

By becoming a sponsor, you'll not only demonstrate your commitment to advancing serverless technologies but also gain visibility within our vibrant community. 

Sponsorship opportunities range from financial contributions to in-kind support, and every sponsorship makes a meaningful impact on the project's success and sustainability.

Support our project by [becoming a Sponsor](https://crowdfunding.lfx.linuxfoundation.org/projects/serverless-workflow).
