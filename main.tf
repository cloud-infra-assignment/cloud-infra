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

module "eks" {
  source = "./modules/eks"

  name               = "app-cluster"
  kubernetes_version = "1.33"

  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnets
  private_subnet_cidrs = module.vpc.private_subnet_cidrs

  node_instance_types = ["t4g.medium"]
  node_ami_type       = "AL2023_ARM_64_STANDARD"
  node_min_size       = 1
  node_max_size       = 3
  node_desired_size   = 2

  tags = var.common_tags
}

# Kubernetes resources (StorageClasses, ALB Controller, etc)
module "k8s" {
  source = "./modules/k8s"

  cluster_name          = module.eks.cluster_name
  cluster_oidc_provider = module.eks.oidc_provider_arn
  vpc_id                = module.vpc.vpc_id

  depends_on = [module.eks]
}

# ArgoCD via Helm
module "argocd" {
  source = "./modules/argocd"

  depends_on = [module.eks]
}