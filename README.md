# ⚡ Tower of Terra ⚡

Stress Testing Dynamic Scaling & Recovery with Terratest

## Introduction

Infrastructure as code (IaC) tools have unlocked numerous powerful benefits both technical and operational, such as automating provisioning and deployment processes or having the ability to easily track infrastructure changes over time within version control.

However, writing and maintaining infrastructure code can still be as tricky as writing other code. As [Gruntwork](https://www.gruntwork.io/) co-founder Yevgeniy Brikman points out[¹](#references):

> Most IaC tools are immature, modern architectures are complicated, and seemingly minor changes to infrastructure code sometimes cause severe bugs, such as wiping out a server, a database, or even an entire data center.
>
> *Here’s the hard truth: most teams are terrified of making changes to their infrastructure code.*

It's easy to see why changing infrastructure code can be frightening. As mentioned above, one false setting around provisioning and/or configuration management can result in a catastrophe if it reaches production. Even if we manage to deploy our infrastructure without errors, there's still a lingering fear that the overall system design might have problems that have yet to be identified (e.g., scalability issues when ingesting larger data volumes). Whether you're a large financial institution dealing with consistency-critical OLTP pipelines or a fledgling startup just starting to build its MVP, your infrastructure is the foundation of your organization's tech stack, and assuring its reliability is critical.

This is where a tool like [Terratest](https://github.com/gruntwork-io/terratest) comes to the rescue. Terratest is a library that makes it easier to develop tests for infrastructure code, enabling us to run IaC tools against real servers and other infrastructure in a real environment such as AWS or Google Cloud.

The goal of this project is to do a deep-dive into infrastructure testing with Terratest by developing a data pipeline and a suite of stress tests that simulate automatic scaling and recovery scenarios.

## Data Pipeline

- **S3** for storing [a large dataset](https://www.cms.gov/OpenPayments/Explore-the-Data/Dataset-Downloads.html). The focus here is to have a dataset that's large enough that it can be used to overwhelm our Kafka cluster. These datasets are managed by Centers for Medicare and Medicaid (CMS) and total roughly [2.2TB](https://www.resdac.org/resconnect/articles/195) (will likely take a subset of this).

- **Node.js** scripts (our "producers") on **EC2** that read from **S3** and relay data to **Kafka**.

- **Kakfa & Apache Zookeeper** on **EC2** for buffering data and serving to topic subscribers. [Might also need EBS? What is the alternative?]

- **Node.js** scripts (our "consumers") on **EC2** that store data in a database. [Any reason to have something more complicated like Spark?]

- **Cassandra** for storing data from consumers.

## DevOps Tools
- **Terraform** for IaC. Still piecing together exactly how this is used for autoscaling, but it likely seems like it will involve [AWS Auto Scaling](https://aws.amazon.com/autoscaling/) which is free and lets us configure powerful settings like Auto Scaling groups (e.g., multiple EC2 instances that can be treated / scaled as a single atomic entity) and set target tracking scaling policies (e.g., always maintain x instances, if at 90% CPU add instance). The Auto Scaling group would encompass the Kafka boxes that we're flooding with messages.

- **Terratest** library for writing & conducting tests.

- **Docker** for **Node.js** scripts. [Also going to see if I can Dockerize Kafka stuff as well so I can avoid CM stuff altogether. It's "stateful", but as long as we can avoid destroying queued messages, we should be ok? The deploy strategy would be similar blue/green deploy instructions [described here](https://aws.amazon.com/blogs/big-data/best-practices-for-running-apache-kafka-on-aws/).

- A monitoring tool [**Prometheus**, **Nagios**, etc]

## Possible stretch goals
- CI/CD pipeline that triggers Terratest testing suite when Terraform changes are committed and merged in.
- Test suites of varying thoroughness and/or fidelity. Perhaps we have two test suites — one for production that reads the data from S3 and one for staging  that generates random data rather instead (to minimize cost and total runtime).
- Using availability zones and integrating the gold standard of battle-testing: [Chaos Monkey](https://github.com/Netflix/chaosmonkey)

---
## References
1. [Open sourcing Terratest: a swiss army knife for testing infrastructure code](https://blog.gruntwork.io/open-sourcing-terratest-a-swiss-army-knife-for-testing-infrastructure-code-5d883336fcd5)
---
Insight DevOps Engineering Project (Class 2018C)
---

# Getting started
Work in progress. Currently using as a way to store notes that might be helpful when finally writing "Getting started" guide.

- Setting environment vars for AWS (I should also add a placeholder in tfvars file)
- Create 'dev' terraform workspace: `terraform workspace new dev`
