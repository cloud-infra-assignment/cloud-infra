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


