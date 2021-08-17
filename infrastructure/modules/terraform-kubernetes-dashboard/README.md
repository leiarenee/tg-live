# Terraform module for Kubernetes Dashboard

This module deploys [Kubernetes Dashboard](https://github.com/kubernetes/dashboard) to your Kubernetes cluster.


### Origin

Repository URL : https://github.com/cookielab/terraform-kubernetes-dashboard/blob/0.11.0/README.md

Terraform Registry URL : https://registry.terraform.io/modules/cookielab/dashboard/kubernetes

## Usage

```terraform
provider "kubernetes" {
  # your kubernetes provider config
}

module "kubernetes_dashboard" {
  source = "cookielab/dashboard/kubernetes"
  version = "0.11.0"

  kubernetes_namespace_create = true
  kubernetes_dashboard_csrf = "<your-csrf-random-string>"
}
```