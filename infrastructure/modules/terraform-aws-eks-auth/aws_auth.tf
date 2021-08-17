
resource "kubernetes_config_map" "aws_auth" {
  count      = var.aws_auth_config.create_eks ? 1 : 0
  depends_on = [null_resource.wait_for_cluster[0]]
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
    labels = merge(
      {
        "app.kubernetes.io/managed-by" = "Terraform"
        # / are replaced by . because label validator fails in this lib 
        # https://github.com/kubernetes/apimachinery/blob/1bdd76d09076d4dc0362456e59c8f551f5f24a72/pkg/util/validation/validation.go#L166
        "terraform.io/module" = "terraform-aws-modules.eks.aws"
      },
      var.aws_auth_config.aws_auth_additional_labels
    )
  }

  data = var.aws_auth_config.data
}

resource "null_resource" "wait_for_cluster" {
  count = var.aws_auth_config.create_eks ? 1 : 0

  provisioner "local-exec" {
    command     = var.aws_auth_config.wait_for_cluster_cmd
    interpreter = var.aws_auth_config.wait_for_cluster_interpreter
    environment = {
      ENDPOINT = var.aws_auth_config.wait_for_cluster_endpoint
    }
  }
}
