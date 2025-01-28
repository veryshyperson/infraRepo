provider "aws" {
  region = var.region
  assume_role {
    role_arn = "arn:aws:iam::058264364931:role/_LocalAdmin"
  }
}

provider "kubernetes" {
  host                   = module.EKS.cluster_endpoint
  cluster_ca_certificate = base64decode( module.EKS.cluster_ca_certificate)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}

# Helm Provider Setup
provider "helm" {
  kubernetes {
  host                   = module.EKS.cluster_endpoint
  cluster_ca_certificate = base64decode( module.EKS.cluster_ca_certificate )
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
  }
}

data "aws_eks_cluster" "cluster_name" {
  name = module.EKS.cluster_name
  depends_on = [module.EKS]
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = module.EKS.cluster_name
  depends_on = [module.EKS]
}