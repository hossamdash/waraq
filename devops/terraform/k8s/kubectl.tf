data "kubectl_file_documents" "aws_secret_manager_mock" {
  content = file("${path.module}/manifests/cluster-secret-store.yaml")
}

resource "kubectl_manifest" "aws_secret_manager_mock" {
  for_each  = data.kubectl_file_documents.aws_secret_manager_mock.manifests
  yaml_body = each.value
}

resource "kubectl_manifest" "waraq_ns" {
  yaml_body = file("${path.module}/manifests/waraq-ns.yaml")
}
