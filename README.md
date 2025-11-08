# cloud-infra

Terraform infrastructure with GitHub Actions CI/CD pipeline using AWS OIDC authentication.

## Git Strategy

This repository follows GitHub Flow with the following principles:

- `main` branch reflects the currently deployed production infrastructure
- All changes must go through pull requests before merging to `main`
- Infrastructure deployments are gated by CI/CD checks before applying to production
- Each merge to `main` is production-ready and reflects live infrastructure state


# Projects AWS Architecture

---

## References

- [VPC Module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/6.5.0)
- [EKS Module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/21.8.0)
- [AWS IAM - Creating OpenID Connect (OIDC) identity providers](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html)
- [GitHub Actions - Configuring OpenID Connect in Amazon Web Services](https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws)
- [Tutorial: Provision an EKS cluster (HashiCorp)](https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks)
- [Reference example main.tf (HashiCorp Education)](https://github.com/hashicorp-education/learn-terraform-provision-eks-cluster/blob/main/main.tf)