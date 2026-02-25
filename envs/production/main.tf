terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
  
  default_tags {
    tags = {
      Environment = var.environment
      ManagedBy   = "Terraform"
      Repository  = "infra-networking"
      Project     = var.project_name
    }
  }
}

module "vpc" {
  source = "../../modules/vpc-networking"

  environment   = var.environment
  project_name  = var.project_name
  vpc_cidr      = var.vpc_cidr
  
  # Subnets públicas (para NAT Gateway, Bastion, etc)
  public_subnets = var.public_subnets
  
  # Subnets privadas para aplicações EKS
  private_app_subnets = var.private_app_subnets
  
  # Subnets privadas para bancos de dados
  private_db_subnets = var.private_db_subnets
  
  # Subnets privadas para Lambda functions
  private_lambda_subnets = var.private_lambda_subnets
  
  availability_zones = var.availability_zones
  
  # NAT Gateway config
  single_nat_gateway     = var.single_nat_gateway  # true para dev, false para prod
  one_nat_gateway_per_az = var.one_nat_gateway_per_az
  
  # DNS
  enable_dns_hostnames = true
  enable_dns_support   = true
}