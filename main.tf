# https://ides.dev/notes/deploying-s3-remote-backend-with-terraform/

resource "aws_s3_bucket" "state" {
  bucket = "cloud-infra-terraform-state-bucket"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket = "cloud-infra-terraform-state-bucket"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}