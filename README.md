# TMNL Live Infrastructure #

This repository is designed to demonstrate deploying [infrastructure as code (IAC)](https://en.wikipedia.org/wiki/Infrastructure_as_code) into dynamic environments as multi-branch [Gitops](https://www.gitops.tech/) architecture using [Terragrunt](https://terragrunt.gruntwork.io/), [Terraform](https://www.terraform.io/) and [AWS Organization](https://aws.amazon.com/organizations/). It heaviliy utilizes [Terragrunt](https://terragrunt.gruntwork.io/) as main automation pipeline framework. [Terragrunt](https://terragrunt.gruntwork.io/) is a thin wrapper that provides extra tools for keeping your configurations [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself), working with multiple [Terraform](https://www.terraform.io/) modules, and managing remote state.

## Pre-Requisites ##

* Terraform > v1.0
* Terragrunt > v31.0
* AWS Client > v2.0
* Jq
  
## Why Gitops multi-branch environments? ##

In conventional approach environment configurations such as production, staging and testing are stored in different folders. This approach has multiple caveats. Any change that is to be implemented across globally in configuration files should be repeated within each environment. Having environments in different branches rather than folders overcomes this issue by using git's standard and reliable mechanisms of merging and branching. Also in contemporary systems with multiple developers, Q/A Stuff, and other stuff who wants to access and test different versions and features of the software at same time creates long queues and time losses if there is one global staging and testing environment. Installing infrastructure and application code synchronously as a complete package into separate isolated environments sourcing from dedicated branches, developers and Q/A Stuff experiences testing new features comfortably without hesitating to damage shared resources. Since these environments are temporary and isolated, infrastructure created within these environments are purged either automatically by a [Cron Job](https://en.wikipedia.org/wiki/Cron) or manually by the user his/her self in order to avoid cloud overcharges. Moreover pull Request mechanism of Git, adds another layer to the system for securely and reliably merging new features into staging and production environments by integrating automation pipeline with Git. [Atlantis](https://www.runatlantis.io/) is a popular open source application to be used for Terraform Pull Request Automation.

Please refer to following documents to get more insight.

* [Readme file](docs/README.md) for more information about each of these technologies and concepts.
* [Gitops Presentation](https://docs.google.com/presentation/d/1-b8t1li_GMtFGteH0Qlr6lxy2P-JiddH/)

## How It Works? ##

Root folder for the dynamic cloud infrastructures is `infrastructure/dynamic`. [terragrunt.hcl](infrastructure/dynamic/terragrunt.hcl) under this folder is used as a parent template file to be included in each configuration where
every sub folder which includes a `terragrunt.hcl` file is a source for a separate infrastructure.

