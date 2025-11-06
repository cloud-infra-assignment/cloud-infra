variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "jenkins_ssh_public_key" {
  type      = string
  sensitive = true
}

variable "common_tags" {
  type = map(string)
  default = {
    Project     = "cloud-infra"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}