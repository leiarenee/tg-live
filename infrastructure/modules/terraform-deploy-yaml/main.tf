

# Terraform module to utilize yaml fields in configuration.
module "k8s_yaml_tf" {
  source = "../terraform-kubernetes-yaml"  
  module_enabled = var.module_enabled
  module_depends_on = var.module_depends_on
  appConfig = local.appConfig
  namespace = var.namespace
}


