# https://ides.dev/notes/deploying-s3-remote-backend-with-terraform/

resource "aws_s3_bucket" "state" {
  bucket = "cloud-infra-terraform-state-bucket"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.19.0"
    }
  }

  backend "s3" {
    bucket       = "cloud-infra-terraform-state-bucket"
    key          = "terraform.tfstate"
    region       = "eu-central-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region
}

# Data source for availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, var.azs_count)
  private_subnets = [for i in range(var.azs_count) : cidrsubnet(var.vpc_cidr, 8, i + 11)]
  public_subnets  = [for i in range(var.azs_count) : cidrsubnet(var.vpc_cidr, 8, i + 1)]

  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Tags for EKS
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  tags = var.common_tags
}