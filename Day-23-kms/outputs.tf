output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "kms_key_id" {
  description = "ID of the customer-managed KMS key"
  value       = aws_kms_key.key.id
}

output "kms_key_arn" {
  description = "ARN of the customer-managed KMS key"
  value       = aws_kms_key.key.arn
}

output "kms_key_alias" {
  description = "Alias of the KMS key"
  value       = aws_kms_alias.key_alias.name
}

output "s3_bucket_name" {
  description = "Name of the encrypted S3 bucket"
  value       = aws_s3_bucket.bucket.id
}

output "s3_bucket_arn" {
  description = "ARN of the encrypted S3 bucket"
  value       = aws_s3_bucket.bucket.arn
}