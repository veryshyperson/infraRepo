resource "kubernetes_ingress_v1" "nginx_alb" {
  depends_on = [ helm_release.nginx-controller, module.eks_blueprints_addons.aws_load_balancer_controller ]
  metadata {
    name      = "nginx-ingress"
    namespace = "ingress"
    annotations = {
      "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
      "alb.ingress.kubernetes.io/ssl-redirect"    = 443
      "alb.ingress.kubernetes.io/target-type"     = "ip"
      "alb.ingress.kubernetes.io/listen-ports"    = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
      "alb.ingress.kubernetes.io/certificate-arn" = module.acm.acm_certificate_arn
    }
  }
  
  
  spec {
    ingress_class_name = "alb"
    rule {
      
      http {
        path {
          path     = "/*"
          backend {
            service {
              name = "ingress-nginx-controller"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}