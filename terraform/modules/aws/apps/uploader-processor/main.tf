resource "random_integer" "unique_identifier" {
  min = 1000
  max = 9999
}

resource "aws_s3_bucket" "uploader-processor" {
  bucket = "${var.env}-uploader-processor-${random_integer.unique_identifier.result}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "uploader" {
  bucket = aws_s3_bucket.uploader-processor.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

/*
#send message to different SQS queue based on upload file type
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.uploader.id

  queue {
    queue_arn     = aws_sqs_queue.queue.arn
    events        = ["s3:ObjectCreated:*"]
    #filter_suffix = ".log"
  }
}

module "sqs" {
  source  = "terraform-aws-modules/sqs/aws"

  name = "uploader"

  create_dlq = true
  redrive_policy = {
    # default is 5 for this module
    maxReceiveCount = 10
  }
}
*/