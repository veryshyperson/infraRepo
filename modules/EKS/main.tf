##########################
#### IAM PERMMISSIONS ####
##########################

data "tls_certificate" "eks" {
  url = module.eks.cluster_oidc_issuer_url
}

resource "aws_iam_openid_connect_provider" "eks" {
  url                 = module.eks.cluster_oidc_issuer_url
  client_id_list      = ["sts.amazonaws.com"]
  thumbprint_list     = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
}

##########################
########## EKS  ##########
##########################


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.stamp
  cluster_version = "1.31"
  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true
  enable_irsa = false

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  eks_managed_node_groups = {
    team_virgin = {
      instance_type = var.ec2_type
      min_size     = var.min_size
      max_size     = var.max_size
      desired_size = var.desired_size
      iam_role_additional_policies = {
        SecretsManagerReadWrite = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
        EBSCSIDriver           = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }
    }
  }

  access_entries = {
    local_admin = {
      principal_arn = "arn:aws:iam::058264364931:user/LocalAdmin"
      type          = "USER"
      policy_associations = {
        admin = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
      }
    }
  }

  tags = {
    Environment = var.environment_tag
    "karpenter.sh/discovery" = var.stamp
    Terraform = "true"
  }

  node_security_group_tags = {
    "karpenter.sh/discovery" = var.stamp
  }
}

#aws eks --region us-east-1  update-kubeconfig --name virgin-eks --role-arn arn:aws:iam::058264364931:role/_LocalAdmin