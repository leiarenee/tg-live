# Terraform module for Kubernetes Metrics Server

This module deploys [Metrics Server](https://github.com/kubernetes-sigs/metrics-server) to your Kubernetes cluster.

### Origin

Original Repository: https://github.com/cookielab/terraform-kubernetes-metrics-server

Terraform Registry: https://registry.terraform.io/modules/cookielab/metrics-server/kubernetes


## Usage

```terraform
provider "kubernetes" {
  # your kubernetes provider config
}

module "metrics_server" {
  source = "cookielab/metrics-server/kubernetes"
  version = "0.9.0"
}
```