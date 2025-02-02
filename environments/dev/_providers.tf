provider "aws" {
  region = var.region
  assume_role {
    role_arn = "arn:aws:iam::058264364931:role/_LocalAdmin"
  }
}

data "aws_eks_cluster" "cluster_name" {
  name       = module.EKS.cluster_name
  depends_on = [module.EKS]
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name       = module.EKS.cluster_name
  depends_on = [module.EKS]
}

provider "kubernetes" {
  host                   = module.EKS.cluster_endpoint
  cluster_ca_certificate = base64decode(module.EKS.cluster_ca_certificate)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.EKS.cluster_name, "--role-arn", "arn:aws:iam::058264364931:role/_LocalAdmin"]
  }
}

provider "helm" {
  kubernetes {
    host                   = module.EKS.cluster_endpoint
    cluster_ca_certificate = base64decode(module.EKS.cluster_ca_certificate)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.EKS.cluster_name, "--role-arn", "arn:aws:iam::058264364931:role/_LocalAdmin"]
    }
  }
}
