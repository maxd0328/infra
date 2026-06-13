variable "kube_config" {
  description = "Kube-config information to connect to the cluster"
  type        = object({
    path    = string
    context = string
  })
}

variable "argocd_version" {
  description = "Version of ArgoCD to deploy to the cluster"
  type        = string
}

variable "environments" {
  description = "The environments to deploy. Expected to match environment names in the GitOps repository"
  type        = set(string)
}

variable "skip_crds" {
  description = "Skip CRDs and deploy only ArgoCD helm chart to the cluster (to avoid plan errors)"
  type        = bool
}

variable "gitops_chart" {
  description = "The source of the GitOps template chart to deploy"
  type        = object({
    repoURL       = string
    chart         = string
    version       = string
    chart_as_path = bool
  })
}

variable "gitops_repo_url" {
  description = "URL of the repository containing the GitOps cluster configuration"
  type        = string
}
