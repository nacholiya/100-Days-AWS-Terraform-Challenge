data "aws_caller_identity" "current" {}

resource "aws_kms_key" "key" {
  description         = "Customer-managed KMS key for encryption at rest of S3 or EBS resources in Day-23"
  enable_key_rotation = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })

}

resource "aws_kms_alias" "key_alias" {
  name          = "alias/day-23-kms-key"
  target_key_id = aws_kms_key.key.id
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${data.aws_caller_identity.current.account_id}-day-23-bucket"

  tags = {
    Name = "day-23-s3-bucket"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.key.arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}