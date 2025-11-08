variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "app-cluster"
}

variable "cluster_oidc_provider" {
  description = "The OIDC provider URL for the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID for the EKS cluster"
  type        = string
}

