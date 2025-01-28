output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_version" {
  value = module.eks.cluster_version
}

output "cluster_ca_certificate" {
  value = module.eks.cluster_certificate_authority_data
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}

output "node_karpenter_role_name" {
  value = module.karpenter.node_iam_role_name
}

output "karpenter_service_account_name" {
  value = module.karpenter.service_account
}

output "karpenter_irsa_arn" {
  value = module.karpenter.iam_role_arn
}

output "karpenter_queue_name" {
  value = module.karpenter.queue_name
}
