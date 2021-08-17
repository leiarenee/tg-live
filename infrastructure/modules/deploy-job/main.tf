locals {
  module_output = module.deploy._output_data
  deployment_output = local.module_output["${var.application_name}:folders.${var.source_folder}:${var.source_folder}/${var.deployment_type}.yml:00"]
}

module "deploy" {
  source = "./terraform-deploy-yaml"
  cluster_id = var.cluster_id
  namespace = var.namespace
  application_name = var.application_name
  source_folder = var.source_folder
  module_enabled = var.module_enabled
  module_depends_on = var.module_depends_on
}

