module "service_account" {
    source = "../../common-patterns/eks-k8s-sa"
    cluster_name = var.cluster_name
    sa_name = var.sa_name
    sa_ns = var.sa_ns
    sa_policy = data.aws_iam_policy_document.sa_policy.json
    
}

data "aws_iam_policy_document" "sa_policy" {
    statement {
      sid = "GetSecret"
      effect = "Allow"
      actions = ["secretsmanager:GetSecretValue"]
      resources = [
        aws_secretsmanager_secret.secret.arn,
        aws_secretsmanager_secret.secret2.arn
        ]
    }
}

