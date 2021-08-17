output "aws_auth_config" {
  value = {
    # Enable/Disable
    create_eks = var.create_eks
    
    # In order to check if cluster is running and up
    wait_for_cluster_cmd = var.wait_for_cluster_cmd
    wait_for_cluster_interpreter = var.wait_for_cluster_interpreter
    wait_for_cluster_endpoint = element(concat(aws_eks_cluster.this.*.endpoint, tolist([""])), 0)

    # For Cluster Permissions and Worker node registration
    aws_auth_additional_labels = var.aws_auth_additional_labels
    data = {
      mapRoles = yamlencode(
        distinct(concat(
          local.configmap_roles,
          var.map_roles,
        ))
      )
      mapUsers    = yamlencode(var.map_users)
      mapAccounts = yamlencode(var.map_accounts)
    }
  }
}