variable "stamp" {
  type = string
}
variable "db_name" {
  type = string
}
variable "db_type" {
  type = string
}
variable "db_engine" {
    type = string 
}
variable "environment_tag" {
  type = string
}
variable "private_subnets" {
    type = list(string) 
}
variable "vpc_id" {
  type = string
}
variable "db_engine_version" {
  type = string
}