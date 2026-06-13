resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_version

  namespace        = "argocd"
  create_namespace = true
}

resource "kubernetes_manifest" "apps" {
  for_each = var.skip_crds ? [] : var.environments

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata   = {
      name      = "gitops-apps-${each.key}"
      namespace = "argocd"
    }
    spec = {
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = each.key
      }
      project = "default"
      sources = [
        {
          repoURL        = var.gitops_repo_url
          targetRevision = "HEAD"
          ref            = "values"
        },
        {
          repoURL        = var.gitops_chart.repoURL
          targetRevision = var.gitops_chart.version

          "${var.gitops_chart.chart_as_path ? "path" : "chart"}" = var.gitops_chart.chart
          
          helm = {
            valueFiles = [
              "$values/apps/base/*.yaml",
              "$values/apps/environments/${each.key}.yaml"
            ]
          }
        }
      ]
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

  depends_on = [helm_release.argocd]
}

resource "kubernetes_manifest" "common" {
  count = var.skip_crds ? 0 : 1

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata   = {
      name      = "gitops-common"
      namespace = "argocd"
    }
    spec = {
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "common"
      }
      project = "default"
      sources = [
        {
          repoURL        = var.gitops_repo_url
          targetRevision = "HEAD"
          ref            = "values"
        },
        {
          repoURL        = var.gitops_chart.repoURL
          targetRevision = var.gitops_chart.version

          "${var.gitops_chart.chart_as_path ? "path" : "chart"}" = var.gitops_chart.chart
          
          helm = {
            valueFiles = [
              "$values/common/base/*.yaml",
              "$values/common/environments/common.yaml"
            ]
          }
        }
      ]
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

  depends_on = [helm_release.argocd]
}
