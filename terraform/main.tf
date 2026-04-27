terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = "dev"
      ManagedBy   = "terraform"
    }
  }
}

module "network" {
  source               = "./modules/network"
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  my_ip                = var.my_ip
}

module "storage" {
  source          = "./modules/storage"
  project_name    = var.project_name
  s3_bucket_name  = var.s3_bucket_name
}

module "database" {
  source             = "./modules/database"
  project_name       = var.project_name
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
  db_instance_class  = var.db_instance_class
  private_subnet_ids = module.network.private_subnet_ids
  sg_rds_id          = module.network.sg_rds_id
}

module "compute" {
  source              = "./modules/compute"
  project_name        = var.project_name
  ami_id              = var.ami_id
  app_instance_type   = var.app_instance_type
  vault_instance_type = var.vault_instance_type
  key_name            = var.key_name
  public_subnet_ids   = module.network.public_subnet_ids
  private_subnet_ids  = module.network.private_subnet_ids
  sg_ec2_id           = module.network.sg_ec2_id
  sg_alb_id           = module.network.sg_alb_id
  sg_vault_id         = module.network.sg_vault_id
  vpc_id              = module.network.vpc_id
}
