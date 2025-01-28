module "karpenter" {
  depends_on = [ module.eks ]
  source = "terraform-aws-modules/eks/aws//modules/karpenter"

  cluster_name = var.stamp

  enable_v1_permissions = true
  
  enable_pod_identity = true
  create_pod_identity_association = true

  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    AmazonEC2SpotFleetTaggingRole = "arn:aws:iam::aws:policy/service-role/AmazonEC2SpotFleetTaggingRole"
    }

}

resource "aws_iam_service_linked_role" "ec2_spot_service_linked_role" {
  aws_service_name = "spot.amazonaws.com"
}
