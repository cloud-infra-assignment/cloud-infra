resource "tls_private_key" "alb" {
  count = var.use_self_signed_cert && var.acm_certificate_arn == "" ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "alb" {
  count = var.use_self_signed_cert && var.acm_certificate_arn == "" ? 1 : 0

  private_key_pem = tls_private_key.alb[0].private_key_pem

  subject {
    common_name  = var.certificate_common_name
    organization = "cloud-infra"
  }

  validity_period_hours = 24 * 365
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "self_signed" {
  count = var.use_self_signed_cert && var.acm_certificate_arn == "" ? 1 : 0

  private_key       = tls_private_key.alb[0].private_key_pem
  certificate_body  = tls_self_signed_cert.alb[0].cert_pem
  certificate_chain = null
}


