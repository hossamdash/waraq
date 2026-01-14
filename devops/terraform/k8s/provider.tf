terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "helm" {
  kubernetes = {
    config_path    = "/etc/rancher/k3s/k3s.yaml"
    config_context = "default"
  }
}

provider "kubectl" {
  config_path    = "/etc/rancher/k3s/k3s.yaml"
  config_context = "default"
}

provider "kubernetes" {
  config_path    = "/etc/rancher/k3s/k3s.yaml"
  config_context = "default"
}

provider "aws" {
  profile = "localstack"
  region  = var.region

  # LocalStack compatibility flags
  skip_credentials_validation = true
  skip_metadata_api_check     = true
}
