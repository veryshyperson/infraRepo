# dev/variables.tf
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}
variable "environment_tag" {
  description = "VPC environment tag"
  type        = string
}
variable "stamp" {
  description = "name to use in every resource"
  type = string 
}