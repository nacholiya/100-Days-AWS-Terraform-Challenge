resource "aws_s3_bucket" "bucket" {
  bucket = "day-46-s3-bucket-8088"

  tags = {
    Name = "Day-46-s3-bucket-8088"
  }
}


resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


## Lifecycle Configuration: This will transition objects based on time and also expire objects after certain days.
resource "aws_s3_bucket_lifecycle_configuration" "s3_lifecycle" {
  bucket = aws_s3_bucket.bucket.bucket

  rule {
    id     = "rule-1"
    status = "Enabled"

    expiration {
      days = 90
    }

    filter {

    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "name" {
  bucket = aws_s3_bucket.bucket.bucket
  name   = "intelligent-tiering-config"

  status = "Enabled"

  tiering {
    days        = 90
    access_tier = "ARCHIVE_ACCESS"
  }
}