resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "9.1.0"
  namespace        = "argocd"
  create_namespace = true

  wait = true
}

locals {
  helm_parameters = concat(
    [
      {
        name  = "ingress.certificateArn"
        value = var.certificate_arn
      }
    ],
    var.image_repository != "" ? [
      {
        name  = "image.repository"
        value = var.image_repository
      }
    ] : [],
    var.image_tag != "" ? [
      {
        name  = "image.tag"
        value = var.image_tag
      }
    ] : []
  )
}

resource "kubernetes_manifest" "microblog_application" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "microblog"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/cloud-infra-assignment/helm-microblog.git"
        targetRevision = "main"
        path           = "microblog"
        helm = {
          parameters = local.helm_parameters
        }
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "default"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        syncOptions = [
          "CreateNamespace=true"
        ]
      }
    }
  }

  field_manager {
    force_conflicts = true
  }

  depends_on = [helm_release.argocd]
}
