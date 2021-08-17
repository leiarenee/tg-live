data "aws_eks_cluster" "cluster" {
  count = var.module_enabled && var.cluster_id != "" ? 1 : 0
  name  = var.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  count = var.module_enabled && var.cluster_id != "" ? 1 : 0
  name  = var.cluster_id
}


provider "helm" {
  kubernetes {
    host     = element(concat(data.aws_eks_cluster.cluster[*].endpoint, list("")), 0)
    token    = element(concat(data.aws_eks_cluster_auth.cluster[*].token, list("")), 0)
    cluster_ca_certificate = base64decode(element(concat(data.aws_eks_cluster.cluster[*].certificate_authority.0.data, list("")), 0))
  }
}

resource "helm_release" "aws-node-termination-handler" {
  name  = "aws-node-termination-handler"
  repository = "https://aws.github.io/eks-charts"
  chart = "aws-node-termination-handler"

  set {
    name  = "namespace"
    value = "kube-system"
  }

  # set {
  #   name  = "enableSpotInterruptionDraining"
  #   value = "true"
  # }

  # set {
  #   name  = "enableScheduledEventDraining"
  #   value = "false"
  # }


}