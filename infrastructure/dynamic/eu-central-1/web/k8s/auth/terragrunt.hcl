# Local variable definitions
locals {
  global_replacements = jsondecode(file(find_in_parent_folders("replace.json")))
  local_replacements = jsondecode(file("replace.json"))
  replacements = merge(local.global_replacements, local.local_replacements)

  # profile="leia"
  # cluster_name="my-testing-cluster"
}

# Module Source 
terraform {
  source = "${get_parent_terragrunt_dir()}/modules/terraform-aws-eks-auth"
  # before_hook "refresh_eks_token" {
  #   commands     = ["apply", "plan","destroy","apply-all","plan-all","destroy-all","init", "init-all"]
  #   execute      = ["aws", "--profile", local.profile, "eks", "update-kubeconfig", "--kubeconfig", ".kubeconfig", "--name", local.cluster_name]
  #  }

}

# Shared TG file
include {
  path = find_in_parent_folders()
}

# Inputs to passed to the TF module
inputs = {
  replace_variables             = merge(local.replacements,{
    }
  )
  aws_auth_config = dependency.cluster.outputs.aws_auth_config
}


dependency "cluster" {
  config_path = "../cluster"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    aws_auth_config={
      data = {}
    }
  } 
  
}
