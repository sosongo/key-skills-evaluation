output "web_server_public_ip" {
  value       = module.ec2.public_ip
  description = "Public IP : Web Server"
}

output "web_server_private_ip" {
  value       = module.ec2.private_ip
  description = "Private IP : Web Server"
}

output "s3_bucket_name" {
  value       = module.s3.bucket_name
  description = "Name of the S3 bucket for logs"
}

output "s3_bucket_arn" {
  value       = module.s3.bucket_arn
  description = "ARN of the S3 bucket for logs"
}