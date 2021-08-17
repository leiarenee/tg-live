

module "metrics-server" {
  
  source  = "cookielab/metrics-server/kubernetes"

  version = "0.10.0"

  kubernetes_namespace                                  = var.kubernetes_namespace
  kubernetes_resources_name_prefix                      = var.kubernetes_resources_name_prefix
  kubernetes_resources_labels                           = var.kubernetes_resources_labels
  kubernetes_deployment_node_selector                   = var.kubernetes_deployment_node_selector
  kubernetes_deployment_tolerations                     = var.kubernetes_deployment_tolerations
  metrics_server_image                                  = var.metrics_server_image
  metrics_server_image_tag                              = var.metrics_server_image_tag
  metrics_server_option_logtostderr                     = var.metrics_server_option_logtostderr
  metrics_server_option_loglevel                        = var.metrics_server_option_loglevel
  metrics_server_option_secure_port                     = var.metrics_server_option_secure_port
  metrics_server_option_tls_cert_file                   = var.metrics_server_option_tls_cert_file
  metrics_server_option_tls_private_key_file            = var.metrics_server_option_tls_private_key_file
  metrics_server_option_kubelet_certificate_authority   = var.metrics_server_option_kubelet_certificate_authority
  metrics_server_option_metric_resolution               = var.metrics_server_option_metric_resolution
  metrics_server_option_kubelet_insecure_tls            = var.metrics_server_option_kubelet_insecure_tls
  metrics_server_option_kubelet_port                    = var.metrics_server_option_kubelet_port
  metrics_server_option_kubelet_preferred_address_types = var.metrics_server_option_kubelet_preferred_address_types

}