
resource "kubernetes_namespace" "namespace" {
  count = var.create_k8s_ns ? 1 : 0
  metadata {
    name = var.sa_ns
  }
  depends_on = [aws_iam_role.iam_role]
}


resource "kubernetes_service_account" "serviceaccount" {
  count = var.create_k8s_sa ? 1 : 0
  metadata {
    name      = var.sa_name
    namespace = var.create_k8s_ns == true ? kubernetes_namespace.namespace[0].id : var.sa_ns  #creation depenency if necessary
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.iam_role.arn
    }
  }
}
