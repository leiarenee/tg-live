locals {
  global_replacements = jsondecode(file(find_in_parent_folders("replace.json")))
  local_replacements = jsondecode(file("replace.json"))
  replacements = merge(local.global_replacements, local.local_replacements)
  all_commands=["apply", "plan","destroy","apply-all","plan-all","destroy-all","validate","validate-all"]
  # Load cluster-level variables
  config = read_terragrunt_config(find_in_parent_folders("config.hcl"))

  # Extract cluster variables
  cluster_config = local.config.locals.cluster_config
  
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "${get_parent_terragrunt_dir()}/modules/terraform-aws-eks"
  before_hook "before_hook_custom" {
    commands     = concat(local.all_commands)
    #execute      = ["cp", "-R", "${get_parent_terragrunt_dir()}/modules/.outsource/registry/terraform-aws-eks", "."]
    execute      = ["cp", "-R", "${get_parent_terragrunt_dir()}/modules/.outsource/registry/terraform-aws-eks/extra_outputs.tf", ".terraform/modules/eks"]
   }
  extra_arguments extra_args {
    commands = get_terraform_commands_that_need_locking()
    env_vars = {"k8s_dependency":false}
  }
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

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
