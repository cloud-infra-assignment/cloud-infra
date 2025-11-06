# VPC Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "Public Subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "Private Subnet IDs"
  value       = module.vpc.private_subnets
}

output "nat_gateway_ips" {
  description = "NAT Gateway Public IPs"
  value       = module.vpc.nat_public_ips
}

# Jenkins Outputs
output "jenkins_instance_id" {
  description = "Jenkins Instance ID"
  value       = module.jenkins.instance_id
}

output "jenkins_public_ip" {
  description = "Jenkins Public IP"
  value       = module.jenkins.public_ip
}

output "jenkins_security_group_id" {
  description = "Jenkins Security Group ID"
  value       = module.jenkins.security_group_id
}