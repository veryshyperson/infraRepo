module "eks_blueprints_addons" {
  source = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.0"

  cluster_name      = var.stamp
  cluster_endpoint  = var.cluster_endpoint
  cluster_version   = var.cluster_version
  oidc_provider_arn = var.oidc_provider_arn

  
  eks_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  enable_aws_load_balancer_controller    = true
  aws_load_balancer_controller = {
        set = [
      {
        name  = "vpcId"
        value = var.vpc_id
      },
      {
        name  = "region"
        value = "us-east-1"
      },
    ]
    timeout = 900
    wait = true
  }
  cert_manager_route53_hosted_zone_arns  = ["arn:aws:route53:::hostedzone/Z0772463WU88EA5BNPTQ"]
  
  tags = {
    terraform = true
    Environment = var.environment_tag
  }
}

#aws eks --region us-east-1  update-kubeconfig --name virgin-eks --role-arn arn:aws:iam::058264364931:role/_LocalAdmin
