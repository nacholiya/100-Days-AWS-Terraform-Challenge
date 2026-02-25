data "aws_caller_identity" "current" {

}

resource "aws_s3_bucket" "bucket" {
  bucket        = "s3-bucket-for-cloudtrail-logs-1808"

  tags = {
    Name = "day-27-s3-bucket"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption_config" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block_policy" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.bucket.id

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "s3:GetBucketAcl"
          ]
          Effect = "Allow"
          Principal = {
            Service = "cloudtrail.amazonaws.com"
          }
          Resource = aws_s3_bucket.bucket.arn
        },
        {
          Action = [
            "s3:PutObject"
          ]
          Effect = "Allow"
          Principal = {
            Service = "cloudtrail.amazonaws.com"
          }
          Resource = "${aws_s3_bucket.bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
          Condition = {
            StringEquals = {
              "s3:x-amz-acl" = "bucket-owner-full-control"
            }
          }
        }
      ]
    }
  )
}

resource "aws_cloudtrail" "account_trail" {
  name                          = "account-trail"
  s3_bucket_name                = aws_s3_bucket.bucket.id
  is_multi_region_trail         = true
  include_global_service_events = true
  enable_logging                = true
  enable_log_file_validation    = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }

  tags = {
    Name = "day-27-cloudtrail"
  }
}