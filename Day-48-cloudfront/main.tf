resource "aws_s3_bucket" "bucket" {
  bucket = "day-48-s3-cloudfront-bucket-8088"

  tags = {
    Name = "Day-48-s3-cloudfront-bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_distribution" "s3_distribution" {

  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_id   = "s3-origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.access_identity.cloudfront_access_identity_path
    }
  }

  enabled = true

  #tfsec:ignore:aws-cloudfront-enforce-https
  default_cache_behavior {
    allowed_methods          = ["GET", "HEAD"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = "s3-origin"
    viewer_protocol_policy   = "allow-all"
    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6" # CachingOptimized
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf" # CORS-S3Origin
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
}

resource "aws_cloudfront_origin_access_identity" "access_identity" {
  comment = "Access Identity for S3 bucket"
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.bucket.id

  policy = jsonencode((
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Principal = {
            AWS = aws_cloudfront_origin_access_identity.access_identity.iam_arn
          }
          Action   = "s3:GetObject"
          Resource = "arn:aws:s3:::${aws_s3_bucket.bucket.id}/*"
        }
      ]
    }
  ))
}