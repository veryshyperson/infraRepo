data "aws_ecrpublic_authorization_token" "token" {}

resource "helm_release" "karpenter" {
  namespace           = "kube-system"
  name                = "karpenter"
  repository          = "oci://public.ecr.aws/karpenter"
  repository_username = data.aws_ecrpublic_authorization_token.token.user_name
  repository_password = data.aws_ecrpublic_authorization_token.token.password
  chart               = "karpenter"
  version             = "1.0.0"
  wait                = false
  
  set {
    name  = "serviceAccount.name"
    value = var.karpenter_service_account_name
  }

  set {
    name  = "settings.clusterName"
    value = var.stamp
  }

  set {
    name  = "settings.clusterEndpoint"
    value = var.cluster_endpoint
  }

  set {
    name  = "settings.interruptionQueue"
    value = var.karpenter_queue_name
  }
}