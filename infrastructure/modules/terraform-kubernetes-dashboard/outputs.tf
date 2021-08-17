output "kubernetes_dashboard_service_name" {
  value = module.kubernetes_dashboard.kubernetes_dashboard_service_name
}

output "kubernetes_dashboard_service_namespace" {
  value = module.kubernetes_dashboard.kubernetes_dashboard_service_namespace
}

output "kubernetes_metrics_scraper_service_name" {
  value = module.kubernetes_dashboard.kubernetes_metrics_scraper_service_name
}

output "kubernetes_metrics_scraper_service_namespace" {
  value = module.kubernetes_dashboard.kubernetes_metrics_scraper_service_namespace
}
