terraform {
  required_version = ">= 1.15.6"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 3.2.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 3.2.0"
    }
  }
}

provider "kubernetes" {
  config_path    = var.kube_config.path
  config_context = var.kube_config.context
}

provider "helm" {
  kubernetes = {
    config_path    = var.kube_config.path
    config_context = var.kube_config.context
  }
}
