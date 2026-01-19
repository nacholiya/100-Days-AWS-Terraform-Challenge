##Creating S3 Bucket
resource "aws_s3_bucket" "challenge_bucket" {
  bucket = "tf-100days-challange-bucket"
}

##Enable Versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.challenge_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

##Enable Encryption ( Srever Side )
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.challenge_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
