output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnets" {
  description = "The CIDR blocks for the public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "The CIDR blocks for the private subnets"
  value       = module.vpc.private_subnets
}

output "vpc_sg" {
  description = "vpc security groups"
  value       = module.vpc.default_security_group_id
}