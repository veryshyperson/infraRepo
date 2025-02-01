resource "helm_release" "prometheus" {
  name      = "prometheus"
  namespace = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart     = "kube-prometheus-stack"
  create_namespace = true
  version   = "67.9.0"
}

module "loki_stack" {
  depends_on = [ helm_release.prometheus ]
  source = "terraform-iaac/loki-stack/kubernetes"

  namespace        = "monitoring"
  create_namespace = false

  provider_type          = "local"
  pvc_storage_class_name = "gp2"
  pvc_access_modes       = ["ReadWriteOnce"]
  persistent_volume_size = "10Gi"

  loki_resources = {
    request_cpu    = "100m"
    request_memory = "256Mi"
  }

  promtail_resources = {
    request_cpu    = "50m"
    request_memory = "128Mi"
  }
}