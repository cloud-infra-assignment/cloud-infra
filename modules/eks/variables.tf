variable "name" {
  description = "EKS cluster name"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where EKS will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for EKS and node groups"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (for node SG rules)"
  type        = list(string)
}

variable "node_instance_types" {
  description = "Instance types for the managed node group"
  type        = list(string)
}

variable "node_ami_type" {
  description = "AMI type for the managed node group"
  type        = string
}

variable "node_min_size" {
  description = "Minimum size of the managed node group"
  type        = number
}

variable "node_max_size" {
  description = "Maximum size of the managed node group"
  type        = number
}

variable "node_desired_size" {
  description = "Desired size of the managed node group"
  type        = number
}

variable "tags" {
  description = "Tags to apply to EKS resources"
  type        = map(string)
}

variable "kms_key_administrators" {
  # Purpose: Avoid perpetual Terraform plan drift caused by different actors (local users vs CI/CD roles)
  # being alternately added as KMS key administrators by the EKS module. By pinning a fixed set of
  # administrator principals here, both local applies and pipeline applies converge on the same policy,
  # preventing the KMS key policy from flip-flopping between principals.
  description = "List of IAM ARNs that administer the EKS KMS key to avoid drift between environments"
  type        = list(string)
  default     = []
}

variable "cluster_creator_principal_arn" {
  description = "Optional IAM principal ARN to grant EKS cluster-admin via access entries (e.g., a developer user)"
  type        = string
  default     = ""
}

variable "github_actions_principal_arn" {
  description = "Optional IAM principal ARN to grant EKS cluster-admin via access entries (e.g., CI role)"
  type        = string
  default     = ""
}


