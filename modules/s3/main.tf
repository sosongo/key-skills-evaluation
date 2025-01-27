## - S3 Bucket for Logs or Static Assets
resource "aws_s3_bucket" "web_logs" {
  bucket = "web-app-logs-${var.project_name}"

  ## - Tags
  tags = {
    Name        = "WebAppLogs-${var.project_name}"
    Environment = "DevOpsTest"
  }
}

## - S3 Bucket : Lifecycle
resource "aws_s3_bucket_lifecycle_configuration" "web_logs_lifecycle" {
  bucket = aws_s3_bucket.web_logs.id

  rule {
    id     = "log-lifecycle"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_transition {
      storage_class = "GLACIER"
      # Aquí puedes especificar 'days' en lugar de usar 'noncurrent_version_transition'
      noncurrent_days = 60
    }
  }
}

## - S3 Bucket : Enable versioning for the bucket
resource "aws_s3_bucket_versioning" "web_logs_versioning" {
  bucket = aws_s3_bucket.web_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

## - S3 Bucket : Public Access Block
resource "aws_s3_bucket_public_access_block" "web_logs_access_block" {
  bucket = aws_s3_bucket.web_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}