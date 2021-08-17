output "output_data" {
  value = module.k8s_yaml_tf.output
  
}

output "input_data" {
  value = {
    cluster_id  = var.cluster_id
    deploy      = var.deploy
  }
}