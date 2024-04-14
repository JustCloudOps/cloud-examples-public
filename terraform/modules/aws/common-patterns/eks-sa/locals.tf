locals {
  eks_cluster_oidc = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
}