module "networking" {
  source   = "../../modules/networking"
  vpc_cidr = var.vpc_cidr
  environment_tag = var.environment_tag
  stamp = "${var.stamp}-vpc"
}

# module "ECR" {
#   source = "../../modules/ECR"
#   environment_tag = var.environment_tag
# }

module "EKS" {
  depends_on = [ module.networking ]
  source = "../../modules/EKS"

  stamp = "${var.stamp}-eks"
  
  vpc_id = module.networking.vpc_id  
  public_subnets = module.networking.public_subnets
  private_subnets = module.networking.private_subnets
  
  ec2_type = var.ec2_type
  min_size = var.min_size
  max_size = var.max_size
  desired_size = var.desired_size
  
  environment_tag = var.environment_tag
}

module "Karpenter" {
  source = "../../modules/Karpenter"

  stamp = "${var.stamp}-eks"
  cluster_endpoint = module.EKS.cluster_endpoint
  
  cluster_ca_certificate = module.EKS.cluster_ca_certificate

  karpenter_irsa_arn = module.EKS.karpenter_irsa_arn
  node_karpenter_role_name = module.EKS.node_karpenter_role_name
  karpenter_service_account_name = module.EKS.karpenter_service_account_name
  karpenter_queue_name = module.EKS.karpenter_queue_name
  
}

module "blueprints" {
  depends_on = [ module.Karpenter ]
  source = "../../modules/blueprints"

  stamp = module.EKS.cluster_name
  cluster_endpoint = module.EKS.cluster_endpoint
  cluster_version = module.EKS.cluster_version
  oidc_provider_arn = module.EKS.oidc_provider_arn
  domain = var.domain
  environment_tag = var.environment_tag
  vpc_id = module.networking.vpc_id
}

module "database" {
  depends_on = [ module.blueprints ]
  source = "../../modules/database"
  stamp = var.stamp
  db_name = var.db_name
  db_type = var.db_type
  db_engine = var.db_engine
  private_subnets = module.networking.private_subnets
  environment_tag = var.environment_tag  
  vpc_id = module.networking.vpc_id
  db_engine_version = var.db_engine_version
}

# aws eks --region us-east-1  update-kubeconfig --name virgin-eks --role-arn arn:aws:iam::058264364931:role/_LocalAdmin
# aws eks --region us-east-1  update-kubeconfig --name virgin-eks --role-arn arn:aws:iam::058264364931:role/_LocalAdmin
# aws eks --region us-east-1  update-kubeconfig --name virgin-eks --role-arn arn:aws:iam::058264364931:role/_LocalAdmin