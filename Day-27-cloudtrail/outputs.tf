############################################
# S3 Bucket Outputs
############################################

output "cloudtrail_s3_bucket_name" {
  description = "Name of the S3 bucket storing CloudTrail logs"
  value       = aws_s3_bucket.bucket.id
}

output "cloudtrail_s3_bucket_arn" {
  description = "ARN of the S3 bucket storing CloudTrail logs"
  value       = aws_s3_bucket.bucket.arn
}

############################################
# CloudTrail Outputs
############################################

output "cloudtrail_name" {
  description = "Name of the CloudTrail trail"
  value       = aws_cloudtrail.account_trail.name
}

output "cloudtrail_arn" {
  description = "ARN of the CloudTrail trail"
  value       = aws_cloudtrail.account_trail.arn
}

output "cloudtrail_home_region" {
  description = "Home region of the CloudTrail trail"
  value       = aws_cloudtrail.account_trail.home_region
}

output "cloudtrail_s3_bucket_attached" {
  description = "S3 bucket configured as the destination for CloudTrail logs"
  value       = aws_cloudtrail.account_trail.s3_bucket_name
}