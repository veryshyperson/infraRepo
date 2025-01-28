variable "stamp" {
  description = "name to use in every resource"
  type = string 
}

variable "environment_tag" {
  description = "environment tag"
  type        = string
}

variable "vpc_id" {
  description = "vpc id"
  type = string
}

variable "private_subnets" {
  description = " the private subnets of the vpc"
  type = list(string)
}

variable "public_subnets" {
  description = " the public subnets of the vpc"
  type = list(string)
}

variable "ec2_type" {
  type        = string
  description = "List of EC2 instance types"
}
variable "min_size" {
  type = number
  description = "EKS managed node group"
}

variable "max_size" {
  type = number
  description = "EKS managed node group"
}

variable "desired_size" {
  type = number
  description = "EKS managed node group"
}
