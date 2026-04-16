## THis is the S3 bucket for storing the logs
resource "aws_s3_bucket" "logging_bucket" {
  bucket = "day-47-s3-logs-logging-bucket-8088"

  tags = {
    Name = "day-47-s3-logs-logging-bucket-8088"
  }
}

## Blocking the Public Access to the Logging Bucket
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.logging_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

## Encrypted the Logging Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "encrypted_logging_bucket" {
  bucket = aws_s3_bucket.logging_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

##  This is the Bucket where the data stores
resource "aws_s3_bucket" "data_bucket" {
  bucket = "day-47-s3-data-bucket-8088"

  tags = {
    Name = "day-47-s3-data-bucket-8088"
  }
}

## This proved the connection betwee logging and data bucket
resource "aws_s3_bucket_logging" "access_logging" {
  bucket = aws_s3_bucket.data_bucket.id

  target_bucket = aws_s3_bucket.logging_bucket.id
  target_prefix = "logs/"
}