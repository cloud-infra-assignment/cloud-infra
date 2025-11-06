variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "jenkins_ssh_public_key" {
  type      = string
  sensitive = true
}

variable "instance_type" {
  type    = string
  default = "t4g.medium"
}

variable "common_tags" {
  type = map(string)
}