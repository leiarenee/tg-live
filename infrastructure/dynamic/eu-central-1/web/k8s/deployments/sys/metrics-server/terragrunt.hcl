

terraform {
  source = "${get_parent_terragrunt_dir()}/modules/terraform-kubernetes-metrics-server"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
 cluster_id = dependency.cluster.outputs.cluster_id
 kubernetes_resources_labels = dependency.cluster.outputs.tags
}

dependencies {
  paths = ["../../../auth","../cluster-auto-scaler"]
}

dependency "cluster" {
  config_path = "../../../cluster"

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
   cluster_id = ""
   tags = {
     mock-tags = "mocked-tags"
   }
  } 

}