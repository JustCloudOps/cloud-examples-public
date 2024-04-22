#Why am I doing this? This method keeps the sa annotation out of a manifest.  This is just unique handling for a public-facing project.
/*
resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.sa_ns
  }
  depends_on = [ module.service_account ]
}


resource "kubernetes_service_account" "serviceaccount" {
  metadata {
    name = var.sa_name
    namespace = var.sa_ns
    annotations = {
      "eks.amazonaws.com/role-arn" = module.service_account.role.arn
    }
  }
  depends_on = [ module.service_account, kubernetes_namespace.namespace ]
}
*/