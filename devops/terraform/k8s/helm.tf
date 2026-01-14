resource "helm_release" "external_secrets" {
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  namespace        = "external-secrets"
  create_namespace = true
  version          = "1.2.1"

  values = [file("${path.module}/templates/external-secrets-values.yaml.tpl")]
}
