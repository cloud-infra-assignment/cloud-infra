output "cluster_name" {
  description = "EKS cluster name"
  value       = module.aws_eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.aws_eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "EKS cluster certificate authority data (base64)"
  value       = module.aws_eks.cluster_certificate_authority_data
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN for the cluster"
  value       = module.aws_eks.oidc_provider_arn
}


