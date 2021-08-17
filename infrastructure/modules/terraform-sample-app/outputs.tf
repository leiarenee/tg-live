output "_output_data" {
  value = module.k8s_yaml_tf.output
  
}

# output "input_data" {
#   value = {
#     cluster_id  = var.cluster_id
#     config      = jsondecode(data.shell_script.merge.output.config)
#   }
# }

# output "hcl_raw" {
#   value = local.hcl_raw
# }

# output "hcl_merged" {
#   value = local.hcl_merged
# }

# output "json_raw" {
#   value = local.json_raw
# }

# output "json_merged" {
#   value = local.json_merged
# }

output "_app_config" {
  value = local.hcl_final_merged
}

output "clusterIp" {
  value = module.k8s_yaml_tf.output["${var.namespace}-${var.application_name}"].service.spec.clusterIp
}

output "endPoint" {
  value = join("", module.k8s_yaml_tf.output["${var.namespace}-${var.application_name}"].service.loadBalancerIngress[*].hostname)
}