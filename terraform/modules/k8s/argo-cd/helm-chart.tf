resource "helm_release" "alb-controller" {
  name             = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argo-cd"
  create_namespace = true
  version          = "6.7.6"
  values = [
    "${file("${path.module}/values.yaml")}"
  ]
}