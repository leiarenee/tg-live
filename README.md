# TMNL Live Infrastructure #

This repository is designed to demonstrate deploying [infrastructure as code (IAC)](https://en.wikipedia.org/wiki/Infrastructure_as_code) into dynamic environments as multi-branch [Gitops](https://www.gitops.tech/) architecture using [Terragrunt](https://terragrunt.gruntwork.io/), [Terraform](https://www.terraform.io/) and [AWS Organization](https://aws.amazon.com/organizations/). It heavily utilizes [Terragrunt](https://terragrunt.gruntwork.io/) as main automation pipeline framework. [Terragrunt](https://terragrunt.gruntwork.io/) is a thin wrapper that provides extra tools for keeping your configurations [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself), working with multiple [Terraform](https://www.terraform.io/) modules, and managing remote state.

## Pre-Requisites ##

* Terraform > v1.0
* Terragrunt > v31.0
* AWS Client > v2.0
* Jq
  
## Why Gitops Multi-Branch Environments? ##

In conventional approach environment configurations such as production, staging and testing are stored in different folders. This approach has multiple caveats. Any change that is to be implemented across globally in configuration files should be repeated within each environment. Having environments in different branches rather than folders overcomes this issue by using git's standard and reliable mechanisms of merging and branching. Also in contemporary systems with multiple developers, Q/A Stuff, and other stuff who wants to access and test different versions and features of the software at same time creates long queues and time losses if there is one global staging and testing environment. Installing infrastructure and application code synchronously as a complete package into separate isolated environments sourcing from dedicated branches, developers and Q/A Stuff experiences testing new features comfortably without hesitating to damage shared resources. Since these environments are temporary and isolated, infrastructure created within these environments are purged either automatically by a [Cron Job](https://en.wikipedia.org/wiki/Cron) or manually by the user his/her self in order to avoid cloud overcharges. Moreover pull Request mechanism of Git, adds another layer to the system for securely and reliably merging new features into staging and production environments by integrating automation pipeline with Git. [Atlantis](https://www.runatlantis.io/) is a popular open source application to be used for Terraform Pull Request Automation.

Please refer to following documents to get more insight.

* [Readme file](docs/README.md) for more information about each of these technologies and concepts.
* [Gitops Presentation](https://docs.google.com/presentation/d/1-b8t1li_GMtFGteH0Qlr6lxy2P-JiddH/)

## How It Works? ##

Root folder for the cloud deployments, is `infrastructure`. [terragrunt.hcl](infrastructure/terragrunt.hcl) under this folder is used as a parent template file to be included in each configuration where
every sub folder which includes a `terragrunt.hcl` file is a source for a separate infrastructure. When [deploy-all.sh](deploy-all.sh) command is run under root folder, it enters into [infrastructure/dynamic](infrastructure/dynamic) folder then runs `terragrunt run-all apply` within the current folder. After running, terragrunt scans all sub folders and detects `terragrunt.hcl` file locations. It prepares a dependency graph and prepares an execution plan then starts the deployments either in parallel or in sequential respecting dependency information. 

Multi-branch configuration file for the multi branch environments is [accounts.hcl](infrastructure/account.hcl). AWS Profile name and other parameters such as kubernetes cluster name, Route53 DNS Zone Id, Domain and sub domain names are configured here.

```hcl
locals {
  # Description
  <branch> = {
    account_name   = "<aws_account_name>"
    aws_account_id = "<aws_account_id>"
    aws_profile    = "<aws-profile-name>"
    bucket_suffix  = "" 
    
    parameters = {
      DOMAIN         = "<sub_domain>.<domain>"
      DNS_ZONE_ID    = "<hosting_zone_id>"
      CLUSTER        = "<cluster-name>"
    }
  }
}
```

When run under automation platform in the cloud, branch name (which is actually the environment name) is extracted using git command to apply respective configuration from [accounts.hcl](infrastructure/account.hcl). Note that [accounts.hcl](infrastructure/account.hcl) file is consumed only by terraform automation software, not by users. In order to run terragrunt in user local machines `.override.hcl` configuration file is used. This file should be located under `infrastructure` folder and can be derived from [sample_override.hcl](infrastructure/sample_override.hcl). Since it changes with respect to users, it is ignored in [.gitignore](infrastructure/.gitignore) file. Refer to the [sample_override.hcl](infrastructure/sample_override.hcl) file and follow instructions to create and modify it according to your specific account information. 

Sample `infrastructure/.override` file:

```hcl
locals {
  #On/Off
  override_active = true
  config = "leia"

  # My Account
  leia = {
    account_name   = "leia"
    aws_account_id = "684353670650"
    aws_profile    = "leia"
    bucket_suffix  = ""
    
    parameters = {
      DOMAIN         = "dev.leiarenee.io"
      SUBDOMAIN      = "test"
      NAMESPACE      = "leia"
      DNS_ZONE_ID    = "Z0765183D4X12U90SGO6"
      CLUSTER        = "k8s-cluster"
    }
  }

}
```

When `.override.hcl` exists terragrunt scripts run according to configuration specified in `config=<name>`field rather than branch name so that users can test specific configuration manually independent of the branch name.

Infrastructure specific inputs are injected into Terraform from respective Json files `inputs.tfvars.json`. Within input files `${variable_name}` notation is used to be replaced by common variables. There is a `replace.json` file under every region as well as every infrastructure to store content of the common variables. A `before_hook` block is triggered before terraform is executed by terragrunt for each job to run the `sh` script written for this purpose. All of the `sh` scripts are located under [infrastructure/modules/scripts](/infrastructure/modules/scripts) folder and copied under Terragrunt cache folder before each execution along with other required Terraform sub modules.

Example input file:

```json
{
  "cluster_name" : "${CLUSTER}",
  "vpc_id"       : "vpc-${CLUSTER}"
}
```

Example replacement file:

```json
{
  "REPO":"https://github.com/leiarenee/my-api.git",
  "BRANCH":"main",
  "APP_NAME":"my-api",
  "USE_REMOTE_CACHE":"true",
  "INVALIDATE_REMOTE_CACHE":"false",
  "CONTAINER_PORT":8000,
  "EXTERNAL_PORT":80,
  "HEALTH_CHECK_TIMEOUT":60,
  "RUN_AUTO_BUILD":false
}
```

Dynamic inputs which are created in runtime as an output of previous terraform stages are passed within terragrunt's input block as part of terragrunt's dependency algorithm.

Example terragrunt input block:

```hcl
# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  replace_variables             = merge(local.replacements,{
    }
  )
  cluster = local.cluster_config
  vpc_config = dependency.vpc.outputs.vpc_config
  ssh_public_key = file("sshkey.pub")
  
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    vpc_config = {
      id = "mocked-vpc-id"
      private_subnets = ["mocked-subnet"]
      cidr_block = "mocked-cidr-block"
    }
  } 
}
```

Terraform modules are stored locally within the `infrastructure/modules` folder. On the other hand these modules are combination of other modules which are downloaded in the runtime and part of [terraform registry](https://registry.terraform.io/) and other reliable and well maintained repositories such as [cloudposse](https://cloudposse.com/). They utilize and customize those modules according to the specific need of the application.

To sum up, the idea is to be able to create a simulated and isolated environment for every user derived from staging to add and test new features reliably and securely. When tested under their cloud environment these new features are then merged into staging again by the terraform automation software by means of git pull request mechanism thus providing a secure way of authenticated and tested deployments. Testing is done by ci/cd pipeline and results are published under pull request page.

## Blue - Green, Blue - Canary - Green Deployments & A-B Testing ##

After specific amount of features are accumulated within staging, the changes including application and infrastructure as a complete package are merged and deployed to the passive production branch and environment synchronously, but this time using real database rather than staging database. Here once again production grade end to end tests are made, new features are checked by quality assurance stuff. Here we have 2 options. We can either pass the traffic directly to new production environment (Blue - Green Deployment), or make it gradually and smoothly by using weighted loading at top level DNS Router such as in [Route53](https://aws.amazon.com/route53/) ( Blue - Canary - Green Deployment). If there happens to be any problem our old production servers are still there and ready to rollback instantly. After a specified time old production environment's infrastructure is destroyed to save cloud costs keeping in mind that we always have the code in old production branch to be used in case. There is yet another option which is called A-B testing. In this case both production environments are kept active for offering two version of the system and evaluate results or try the new features for a long time in a custom control group then pass thoroughly to the new environment.

## Cleaning Up Unnecessary Resources ##

Another important part of the system is to clean up unused resources. For instances user environments are only created on demand and purged by user or automatically after working hours by a scheduled cron job. This will save a lot of money since most of the time these resources are only needed in day time for about 3-4 hours to make tests. Keeping them continuously 24 Hours a day would be enormous amount of waste, hence we should take it into consideration seriously. We use [AWS Nuke](https://github.com/rebuy-de/aws-nuke) Library to purge isolated environments. Terragrunt is not so successful to destroy resources as much as it creates them. If any problem occurs during destroy process, you end up with a mess of resources that not only can be destroyed any more because of dependency relations but also these resources prevent re-deployment of the same infrastructure violating `identical name` rule. You can find an automation ready implementation here [leiarenee/aws-cloud-scripts/nuke](https://github.com/leiarenee/aws-cloud-scripts/tree/main/nuke). A cron job is working in my account which triggers every night for every sub organizational accounts I have, to keep my account clean in order to prevent AWS incurring surprisingly high cloud costs. [AWS Codebuild](https://aws.amazon.com/codebuild/) is utilized to run automated nuke scripts.

## Build Stage - Remote Docker build for Codebuild ##

Source folder for Codebuild is located under [web/build/api/flask](infrastructure/dynamic/eu-central-1/web/build/api/flask). We use a customized version of cloudposse codebuild repository. First codebuid environment is deployed by terraform. Then [aws-code-build script](https://github.com/leiarenee/aws-cloud-scripts/tree/main/aws-codebuild-run) is executed by terraform. This script is written by me to initiate a codebuild job, fetch and trace the related log stream from [AWS Cloudwatch](https://aws.amazon.com/cloudwatch/). When codebuild job is run, first it fetches the repository from the version control system, in this case github. Then it starts execution following instructions in [buildspec.yml](/infrastructure/buildspec.yml). In order to standardize process we keep `buildspec.yaml` simple and small and call another bash script file `codebuild.sh` which is part of the source repository. Codebuild exports environment variables and runs the docker build following the instructions in `codebuild.sh` file. If any error occurs during the build time [aws-code-build script](https://github.com/leiarenee/aws-cloud-scripts/tree/main/aws-codebuild-run) returns with a non-zero exit code, terminating the remaining dependent deployments. After a successful build the image is uploaded into [AWS ECR](https://aws.amazon.com/ecr/). When script returns with a zero exit code terraform publishes the outputs such as container image ECR repository address to be consumed by next terragrunt stage in this case deployment to kubernetes cluster.

