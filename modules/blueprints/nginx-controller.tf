resource "helm_release" "nginx-controller" {
  depends_on = [ module.eks_blueprints_addons ]
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress"
  create_namespace = true
  set {
    name  = "controller.service.type"
    value = "ClusterIP"
  }
  timeout = 900
  wait    = true
}