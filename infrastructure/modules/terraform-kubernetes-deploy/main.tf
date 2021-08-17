


# Terraform module to utilize yaml fields in configuration.
module "k8s_yaml_tf" {
  module_enabled = var.module_enabled
  module_depends_on = var.module_depends_on
  source = "../terraform-kubernetes-yaml"  
  appConfig = {
      "${var.namespace}-${var.application_name}" = {
        k8s = {
          for deployment, config in var.deploy:
            deployment => config
        }
      } 
    }
}