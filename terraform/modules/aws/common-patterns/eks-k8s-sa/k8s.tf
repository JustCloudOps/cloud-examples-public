
resource "kubernetes_namespace" "namespace" {
  count = var.deploy_k8s_ns_sa ? 1 : 0
  metadata {
    name = var.sa_ns
  }
  depends_on = [aws_iam_role.iam_role]
}


resource "kubernetes_service_account" "serviceaccount" {
  count = var.deploy_k8s_ns_sa ? 1 : 0
  metadata {
    name      = var.sa_name
    namespace = var.sa_ns
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.iam_role.arn
    }
  }
  depends_on = [kubernetes_namespace.namespace]
}
