resource "aws_iam_role" "iam_role" {
  name = "${var.cluster_name}-${var.sa_ns}-${var.sa_name}"
  description = "IAM Role for EKS Service Account"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
    statement {
      effect = "Allow"
      actions = ["sts:AssumeRoleWithWebIdentity"]
      principals {
        type = "Federated"
        identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.eks_cluster_oidc}"]
      }
      condition {
        test = "StringEquals"
        variable = "${local.eks_cluster_oidc}:sub"
        values = ["system:serviceaccount:${var.sa_ns}:${var.sa_name}"]
      }
    }
}

resource "aws_iam_policy" "policy" {
    name = "${var.cluster_name}-${var.sa_ns}-${var.sa_name}"
    policy = var.sa_policy
  
}

resource "aws_iam_role_policy_attachment" "policy_attach" {
    role = aws_iam_role.iam_role.name
    policy_arn = aws_iam_policy.policy.arn
}


