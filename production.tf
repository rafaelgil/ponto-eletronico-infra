/*====
Variables used across all modules
======*/
locals {
  production_availability_zones = ["us-east-1a", "us-east-1b"]
  environment                   = "ponto-eletronico"
}

provider "aws" {
  region = var.region
}

terraform {

  required_providers {
     aws = {
       source  = "hashicorp/aws"
       version = "~> 5.0"
     }
   }

  backend "s3" {
    bucket  = "tfstate-backend-ponto-eletronico-infra"
    key     = "terraform-deploy.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

module "networking" {
  source               = "./modules/networking"
  environment          = local.environment
  vpc_cidr             = "10.0.0.0/16"
  public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidr = ["10.0.10.0/24", "10.0.20.0/24"]
  region               = var.region
  availability_zones   = local.production_availability_zones
}

module "rds" {
  source            = "./modules/rds"
  environment       = local.environment
  allocated_storage = "20"
  subnet_ids        = module.networking.private_subnets_id
  vpc_id            = module.networking.vpc_id
  instance_class    = "db.t3.micro"
}

module "ecs" {
  source             = "./modules/ecs"
  environment        = local.environment
  vpc_id             = module.networking.vpc_id
  availability_zones = local.production_availability_zones
  subnets_ids        = module.networking.private_subnets_id
  public_subnet_ids  = module.networking.public_subnets_id
  security_groups_ids = [
    module.networking.security_groups_ids,
    module.rds.db_access_sg_id,
  ]
}