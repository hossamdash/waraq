locals {
  github_repos = {
    waraq = {
      owner = "hossamdash"
    }
  }
}

resource "tls_private_key" "argocd_repo_creds_key" {
  for_each = local.github_repos

  algorithm = "ED25519"
}

module "argocd_repo_creds_secret" {
  for_each = local.github_repos

  source  = "terraform-aws-modules/secrets-manager/aws"
  version = "2.1.0"

  # Secret
  name                    = "argocd-openssh-public-key-${each.key}"
  description             = "ArgoCD SSH public key for repo ${each.key}, should be added as deploy key to the repo"
  recovery_window_in_days = 0
  ignore_secret_changes   = true

  # Policy
  block_public_policy = true
  secret_string       = tls_private_key.argocd_repo_creds_key[each.key].public_key_openssh

  tags = {
    team = "devops"
  }
}


# Kubernetes secret for ArgoCD repository credentials
resource "kubernetes_secret" "argocd_repo_creds" {
  for_each = local.github_repos

  metadata {
    name      = "argocd-repo-creds-${each.key}"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }
  data = {
    "name"          = each.key
    "sshPrivateKey" = tls_private_key.argocd_repo_creds_key[each.key].private_key_openssh
    "type"          = "git"
    "url"           = "git@github.com:${each.value.owner}/${each.key}.git"
  }

  # depends on it for namespace creation
  depends_on = [
    helm_release.argocd,
  ]
}
