data "aws_eks_cluster" "cluster" {
  count = var.module_enabled && var.cluster_id != "" ? 1 : 0
  name  = var.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  count = var.module_enabled && var.cluster_id != "" ? 1 : 0
  name  = var.cluster_id
}

provider "kubernetes" {
  host                   = element(concat(data.aws_eks_cluster.cluster[*].endpoint, list("")), 0)
  cluster_ca_certificate = base64decode(element(concat(data.aws_eks_cluster.cluster[*].certificate_authority.0.data, list("")), 0))
  token                  = element(concat(data.aws_eks_cluster_auth.cluster[*].token, list("")), 0)
  load_config_file       = false
}


# Terraform module to utilize yaml fields in configuration.
module "k8s_yaml_tf" {
  module_enabled = var.module_enabled
  module_depends_on = var.module_depends_on
  source = "github.com/brcnblc/k8s-terraform-yaml" 
  appConfig = local.appConfig
  namespace = var.namespace
}

