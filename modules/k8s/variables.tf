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

variable "aws_region" {
  description = "AWS region for ALB controller Helm chart configuration"
  type        = string
}

variable "create_image_pull_secret" {
  description = "Whether to create a docker-registry imagePullSecret for GHCR"
  type        = bool
  default     = true
}

variable "image_pull_secret_name" {
  description = "Name of the imagePullSecret to create"
  type        = string
  default     = "ghcr-secret"
}

variable "image_pull_secret_namespace" {
  description = "Namespace where the imagePullSecret will be created"
  type        = string
  default     = "default"
}

variable "ghcr_username" {
  description = "GitHub Container Registry (GHCR) username"
  type        = string
  default     = ""
}

variable "ghcr_token" {
  description = "GitHub Container Registry (GHCR) personal access token (PAT)"
  type        = string
  sensitive   = true
  default     = ""
}
