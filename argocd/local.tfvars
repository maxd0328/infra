kube_config = {
  path    = "~/.kube/config"
  context = "k3d-intranet-cluster"
}
argocd_version = "9.5.21"
environments   = ["stg"]
skip_crds      = false
gitops_chart   = {
  repoURL       = "https://github.com/maxd0328/charts.git"
  chart         = "gitops/"
  version       = "HEAD"
  chart_as_path = true
}
gitops_repo_url = "https://github.com/maxd0328/gitops.git"
