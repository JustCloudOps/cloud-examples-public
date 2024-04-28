module "uploader_service_account" {
  source           = "../../common-patterns/eks-k8s-sa"
  sa_name          = "uploader"
  sa_ns            = "uploader"
  cluster_name     = var.cluster_name
  sa_policy_doc    = data.aws_iam_policy_document.uploader_service.json
  deploy_k8s_ns_sa = true
}

data "aws_iam_policy_document" "uploader_service" {
  statement {
    sid = "UploadFile"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.uploader-processor.arn
    ]
  }
}
