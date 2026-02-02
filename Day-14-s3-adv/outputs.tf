output "restricted_bucket_name" {
  description = "Name of the S3 bucket with restricted access"
  value       = aws_s3_bucket.restricted_bucket.bucket
}

output "restricted_bucket_arn" {
  description = "ARN of the restricted S3 bucket"
  value       = aws_s3_bucket.restricted_bucket.arn
}

output "iam_policy_name" {
  description = "Name of the bucket-scoped IAM policy"
  value       = aws_iam_policy.restricted_bucket_policy.name
}

output "iam_policy_arn" {
  description = "ARN of the bucket-scoped IAM policy"
  value       = aws_iam_policy.restricted_bucket_policy.arn
}

output "attached_iam_role" {
  description = "IAM role to which the restricted policy is attached"
  value       = aws_iam_role.ec2_role.name
}
