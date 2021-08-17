

resource "kubernetes_namespace" "kubernetes_dashboard" {
  count = var.kubernetes_namespace_create ? 1 : 0

  metadata {
    name = var.kubernetes_namespace
  }
}

module "kubernetes_dashboard" {
  source = "cookielab/dashboard/kubernetes"
  version = "0.11.0"

  kubernetes_dashboard_csrf                             = var.kubernetes_dashboard_csrf
  kubernetes_namespace                                  = var.kubernetes_namespace_create ? join("",kubernetes_namespace.kubernetes_dashboard[*].id) : var.kubernetes_namespace
  kubernetes_namespace_create                           = false
  kubernetes_resources_name_prefix                      = var.kubernetes_resources_name_prefix
  kubernetes_resources_labels                           = var.kubernetes_resources_labels
  kubernetes_deployment_image_registry                  = var.kubernetes_deployment_image_registry
  kubernetes_deployment_image_tag                       = var.kubernetes_deployment_image_tag
  kubernetes_deployment_metrics_scraper_image_registry  = var.kubernetes_deployment_metrics_scraper_image_registry
  kubernetes_deployment_metrics_scraper_image_tag       = var.kubernetes_deployment_metrics_scraper_image_tag
  kubernetes_deployment_node_selector                   = var.kubernetes_deployment_node_selector
  kubernetes_deployment_tolerations                     = var.kubernetes_deployment_tolerations
  kubernetes_service_account_name                       = var.kubernetes_service_account_name
  kubernetes_secret_certs_name                          = var.kubernetes_secret_certs_name
  kubernetes_role_name                                  = var.kubernetes_role_name
  kubernetes_role_binding_name                          = var.kubernetes_role_binding_name
  kubernetes_deployment_name                            = var.kubernetes_deployment_name
  kubernetes_service_name                               = var.kubernetes_service_name
  kubernetes_ingress_name                               = var.kubernetes_ingress_name

}