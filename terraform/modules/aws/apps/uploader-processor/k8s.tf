module "uploader_service_account" {
  source           = "../../common-patterns/eks-k8s-sa"
  sa_name          = "uploader"
  sa_ns            = "uploader"
  cluster_name     = var.cluster_name
  sa_policy_doc    = data.aws_iam_policy_document.uploader_service.json
  create_k8s_ns = true
  create_k8s_sa = true
}

data "aws_iam_policy_document" "uploader_service" {
  statement {
    sid = "UploadFile"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.uploader-processor.arn}/*"
    ]
  }
}

module "uploader_parameterstore_service_account" {
  source        = "../../common-patterns/eks-k8s-sa"
  sa_name       = "uploader-parameterstore"
  sa_ns         = "uploader"
  cluster_name  = var.cluster_name
  sa_policy_doc = data.aws_iam_policy_document.uploader_parameterstore.json
  create_k8s_ns = false
  create_k8s_sa = true
  depends_on = [ module.uploader_service_account ]
}

data "aws_iam_policy_document" "uploader_parameterstore" {
  statement {
    sid = "GetParameter"

    actions = [
      "ssm:GetParameter",
    ]

    resources = [
      aws_ssm_parameter.uploader_bucket.arn,
      aws_ssm_parameter.uploader_queue.arn
    ]
  }
}