module "vpc" {
  source = "./modules/vpc"

  common_tags = var.common_tags
}

module "jenkins" {
  source = "./modules/jenkins"

  vpc_id                 = module.vpc.vpc_id
  public_subnet_ids      = module.vpc.public_subnets
  jenkins_ssh_public_key = var.jenkins_ssh_public_key
  common_tags            = var.common_tags
}