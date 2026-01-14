resource "helm_release" "external_secrets" {
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  namespace        = "external-secrets"
  create_namespace = true
  version          = "1.2.1"

  values = [file("${path.module}/templates/external-secrets-values.yaml.tpl")]
}

resource "kubernetes_namespace" "vault" {
  metadata {
    name = "vault"
    labels = {
      used-as = "aws-secrets-simulator"
    }
  }
}

resource "kubectl_manifest" "cluster_secret_store" {
  yaml_body = file("${path.module}/manifests/cluster-secret-store.yaml")

  depends_on = [
    kubernetes_namespace.vault
  ]
}

resource "helm_release" "argocd" {
  chart      = "argo-cd"
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  namespace  = "argocd"
  # TODO: this was last working version tested, should upgrade to latest version
  version          = "8.5.6"
  create_namespace = true
  values = [
    file("${path.module}/templates/argocd-values.yaml"),
  ]
}
