variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "cloud-infra-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs_count" {
  description = "Number of Availability Zones"
  type        = number
  default     = 2
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "single_nat_gateway" {
  type    = bool
  default = false
}

variable "common_tags" {
  type = map(string)
}