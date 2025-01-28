variable "instance_categories" {
  type    = list(string)
  default = ["t"]
}

variable "instance_families" {
  type    = list(string)
  default = ["t3"]
}

variable "instance_cpu" {
  type    = list(string)
  default = ["4"]
}

variable "capacity_types" {
  type    = list(string)
  default = ["spot", "on-demand"]
}

variable "cpu_limits" {
  type    = number
  default = 300
}

variable "ami_family" {
  type    = string
  default = "AL2023"
}

variable "stamp" {
  type = string
}

variable "cluster_endpoint" {
  type = string
}

variable "node_karpenter_role_name" {
  type = string
}

variable "cluster_ca_certificate" {
  type = string
}

variable "karpenter_queue_name" {
  type = string
}

variable "karpenter_irsa_arn" {
  type = string
}

variable "karpenter_service_account_name" {
  type = string
}


