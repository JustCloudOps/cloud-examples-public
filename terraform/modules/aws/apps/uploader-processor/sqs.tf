resource "aws_sqs_queue" "uploader_queue" {
  name = "${var.env}-uploader-processor-${random_integer.unique_identifier.result}"
}

resource "aws_sqs_queue_policy" "uploader_queue_policy" {
  queue_url = aws_sqs_queue.uploader_queue.id
  policy    = data.aws_iam_policy_document.uploader_queue_policy_doc.json
}

data "aws_iam_policy_document" "uploader_queue_policy_doc" {
  statement {
    sid = "AllowS3"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    actions = [
      "sqs:SendMessage",
    ]
    resources = [
      aws_sqs_queue.uploader_queue.arn
    ]
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:s3:*:*:${aws_s3_bucket.uploader-processor.id}"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = ["${var.account_id}"]
    }
  }
}

resource "aws_ssm_parameter" "uploader_queue" {
  name  = "/${var.env}/${basename(abspath(path.module))}/queue"
  type  = "String"
  value = aws_sqs_queue.uploader_queue.id
}