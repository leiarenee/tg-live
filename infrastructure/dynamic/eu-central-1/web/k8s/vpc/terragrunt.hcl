locals {
  global_replacements = jsondecode(file(find_in_parent_folders("replace.json")))
  local_replacements = jsondecode(file("replace.json"))
  replacements = merge(local.global_replacements, local.local_replacements)

  # Load cluster-level variables
  config = read_terragrunt_config(find_in_parent_folders("config.hcl"))

  # Extract cluster variables
  cluster = local.config.locals.cluster_config
  vpc = local.cluster.vpc

}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "${get_parent_terragrunt_dir()}/modules/terraform-aws-vpc"
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
  vpc = local.vpc 
  
}

# dependencies {
#   paths = ["../../vpc-default"]
# }
