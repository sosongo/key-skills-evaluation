output "bucket_name" {
  value = aws_s3_bucket.web_logs.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.web_logs.arn
}