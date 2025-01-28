resource "kubernetes_namespace" "external_secrets" {
  metadata {
    name = "external-secrets"
  }
}

resource "helm_release" "external-secrets" {
  depends_on = [kubernetes_namespace.external_secrets]
  name       = "external-secrets"
  chart      = "external-secrets"
  namespace  = "external-secrets"
  repository = "https://charts.external-secrets.io/"
  version    = "0.12.1"

  set {
    name  = "installCRDs"
    value = true
  }

  # Add cleanup settings
  cleanup_on_fail = true
  force_update    = false
  recreate_pods   = false

  # Add timeouts
  timeout = 600
  wait    = true
}

# Add explicit CRD cleanup
resource "null_resource" "cleanup_crds" {
  depends_on = [helm_release.external-secrets]

  triggers = {
    helm_release = helm_release.external-secrets.id
    namespace    = kubernetes_namespace.external_secrets.metadata[0].name
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      sleep 10
      kubectl delete crd secretstores.external-secrets.io --ignore-not-found=true
      kubectl delete crd clustersecretstores.external-secrets.io --ignore-not-found=true
      kubectl delete crd externalsecrets.external-secrets.io --ignore-not-found=true
      kubectl delete crd clusterexternalsecrets.external-secrets.io --ignore-not-found=true
      sleep 10
    EOT
  }
}