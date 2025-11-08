variable "certificate_arn" {
  description = "ACM certificate ARN to pass to the microblog chart (ingress.certificateArn). Empty to disable."
  type        = string
  default     = ""
}

variable "image_repository" {
  description = "Container image repository to pass to the Helm chart (image.repository). Empty to use chart default."
  type        = string
  default     = ""
}

variable "image_tag" {
  description = "Container image tag to pass to the Helm chart (image.tag). Empty to use chart default."
  type        = string
  default     = ""
}


