module "aws_eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.8"

  name               = var.name
  kubernetes_version = var.kubernetes_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  enable_cluster_creator_admin_permissions = false
  endpoint_public_access                   = true
  create_cloudwatch_log_group              = false

  # Grant cluster-admin access to both the original cluster creator and GitHub Actions role
  access_entries = {
    cluster_creator = {
      principal_arn = "arn:aws:iam::339051025574:user/awscli"
      type          = "STANDARD"
      access_policy_associations = {
        cluster_admin = {
          access_scope = {
            type = "cluster"
          }
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
        }
      }
    }
    github_actions = {
      principal_arn = "arn:aws:iam::339051025574:role/GitHubActionsRole"
      type          = "STANDARD"
      access_policy_associations = {
        cluster_admin = {
          access_scope = {
            type = "cluster"
          }
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
        }
      }
    }
  }

  eks_managed_node_groups = {
    default = {
      instance_types = var.node_instance_types
      ami_type       = var.node_ami_type
      min_size       = var.node_min_size
      max_size       = var.node_max_size
      desired_size   = var.node_desired_size
    }
  }

  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = module.irsa_ebs_csi.iam_role_arn
    }
  }

  tags = var.tags
}

module "irsa_ebs_csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 5.0"

  create_role                   = true
  role_name                     = "${var.name}-ebs-csi"
  provider_url                  = module.aws_eks.oidc_provider
  role_policy_arns              = ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
  tags                          = var.tags
}
