locals {
  apps = {
    katib = {
      repo                 = "waraq"
      owner                = "hossamdash"
      kubernetes_namespace = "waraq"
    }
  }
}

resource "kubectl_manifest" "argo_app" {
  for_each = local.apps

  yaml_body = templatefile(
    "${path.module}/manifests/argo-app.yaml.tpl",
    {
      APP_NAME             = each.key
      GITHUB_OWNER         = each.value.owner
      GITHUB_REPO          = each.value.repo
      KUBERNETES_NAMESPACE = each.value.kubernetes_namespace
    }
  )

  depends_on = [
    helm_release.argocd,
  ]
}
