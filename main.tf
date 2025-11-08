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
  node_max_size       = 2
  node_desired_size   = 2

  tags = var.common_tags

  # Pin KMS key admins to stable principals to avoid drift between local developer applies
  # and CI/CD applies (each may try to make itself the admin, causing policy flip-flops).
  # This ensures the KMS key policy remains stable regardless of who runs terraform apply.
  kms_key_administrators = [
    "arn:aws:iam::339051025574:role/GitHubActionsRole",
    "arn:aws:iam::339051025574:user/awscli"
  ]

  # Parameterized EKS access entries (remove hardcoded ARNs from module)
  cluster_creator_principal_arn = "arn:aws:iam::339051025574:user/awscli"
  github_actions_principal_arn  = "arn:aws:iam::339051025574:role/GitHubActionsRole"
}

# Kubernetes resources (StorageClasses, ALB Controller, etc)
module "k8s" {
  source = "./modules/k8s"

  cluster_name                = module.eks.cluster_name
  cluster_oidc_provider       = module.eks.oidc_provider_arn
  vpc_id                      = module.vpc.vpc_id
  aws_region                  = var.aws_region
  create_image_pull_secret    = true
  image_pull_secret_name      = "ghcr-secret"
  image_pull_secret_namespace = "default"
  ghcr_username               = var.ghcr_username
  ghcr_token                  = var.ghcr_token

  depends_on = [module.eks]
}

# ArgoCD via Helm
module "argocd" {
  source = "./modules/argocd"

  # Choose provided ACM cert, or auto-generated self-signed ACM cert if enabled
  certificate_arn  = var.acm_certificate_arn != "" ? var.acm_certificate_arn : (var.use_self_signed_cert ? aws_acm_certificate.self_signed[0].arn : "")
  image_repository = var.app_image_repository
  image_tag        = var.app_image_tag

  depends_on = [module.eks, module.k8s]
}