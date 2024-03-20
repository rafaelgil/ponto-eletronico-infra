variable "environment" {
  description = "The environment"
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "availability_zones" {
  description = "The azs to use"
}

variable "security_groups_ids" {
  description = "The SGs to use"
}

variable "subnets_ids" {
  description = "The private subnets to use"
}

variable "public_subnet_ids" {
  description = "The public subnets to use"
}

variable "repository_name" {
  description = "repository name"
  default = "ponto-eletronico-app"
}