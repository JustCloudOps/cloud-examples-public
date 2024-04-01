resource "helm_release" "alb-controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.7.2"
  set {
    name = "clusterName"
    value = var.cluster_name
  }
  set {
    name = "serviceAccount.name"
    value = var.alb_controller_sa_name
  }
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.alb_controller.arn
  }
  depends_on = [aws_iam_role_policy_attachment.alb_controller_attach]
}