terraform {
  required_providers {
      kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
  }
}

provider "kubectl" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
  load_config_file       = true
}

data "aws_eks_cluster" "cluster_name" {
  name = var.stamp
  depends_on = [ helm_release.karpenter ]
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = data.aws_eks_cluster.cluster_name.name
  depends_on = [ helm_release.karpenter ]
}

resource "kubectl_manifest" "karpenter_node_class" {
  depends_on = [ data.aws_eks_cluster_auth.cluster_auth ]
  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1
    kind: EC2NodeClass
    metadata:
      name: default
    spec:
      amiFamily: AL2
      role: ${var.node_karpenter_role_name}
      subnetSelectorTerms:
        - tags:
            karpenter.sh/discovery: ${var.stamp}
      amiSelectorTerms:
        - alias: al2@latest
      securityGroupSelectorTerms:
        - tags:
            karpenter.sh/discovery: ${var.stamp}
  YAML
}

resource "kubectl_manifest" "karpenter_node_pool" {
 depends_on = [ kubectl_manifest.karpenter_node_class ]
 yaml_body = <<-YAML
apiVersion: karpenter.sh/v1
kind: NodePool
metadata:
  name: default
spec:
  template:
    spec:
      nodeClassRef:
        kind: EC2NodeClass
        name: default
      requirements:
        - key: karpenter.k8s.aws/instance-category
          operator: In
          values: ["t", "m", "c"]
        - key: karpenter.k8s.aws/instance-family
          operator: In
          values: ["t3", "t4g", "m5", "m6g", "c5", "c6g"]
        - key: karpenter.k8s.aws/instance-cpu
          operator: In
          values: ["2", "4", "8", "16"]
        - key: karpenter.sh/capacity-type
          operator: In
          values: ["spot", "on-demand"]
  limits:
    cpu: 500
  disruption:
    consolidationPolicy: WhenEmpty
    consolidateAfter: 30s
 YAML
}