resource "random_integer" "unique_identifier" {
  min = 1000
  max = 9999
}

resource "aws_s3_bucket" "uploader-processor" {
  bucket        = "${var.env}-uploader-processor-${random_integer.unique_identifier.result}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "uploader" {
  bucket = aws_s3_bucket.uploader-processor.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.uploader-processor.id

  queue {
    queue_arn = aws_sqs_queue.uploader_queue.arn
    events    = ["s3:ObjectCreated:*"]
  }
  depends_on = [ aws_sqs_queue.uploader_queue ]
}

resource "aws_ssm_parameter" "uploader_bucket" {
  name  = "/${var.env}/${basename(abspath(path.module))}/bucket"
  type  = "String"
  value = aws_s3_bucket.uploader-processor.id
}




