

terraform {
  #source = "git::git@github.com:bettermarks/terraform-modules.git//terraform-kubernetes-dashboard"
  source = "${get_parent_terragrunt_dir()}/modules/terraform-kubernetes-dashboard"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  cluster_id = dependency.cluster.outputs.cluster_id
  
  kubernetes_dashboard_csrf = "csrf.8877_"
  kubernetes_namespace_create = true
  kubernetes_namespace = "kubernetes-dashboard"
  kubernetes_resources_labels = dependency.cluster.outputs.tags

  kubernetes_deployment_node_selector = {
    "beta.kubernetes.io/os" = "linux"
  }

  kubernetes_deployment_tolerations = [
    {
      key = "node-role.kubernetes.io/master"
      operator = "Equal"
      value = ""
      effect = "NoSchedule"
    }
  ]

}

dependencies {
  paths = ["../../../auth","../cluster-auto-scaler","../metrics-server"]
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