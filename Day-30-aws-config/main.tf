resource "aws_s3_bucket" "bucket" {
  bucket = "day-30-s3-config-bucket"

  tags = {
    Name = "day-30-s3-bucket"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "pb_block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_role" "config_role" {
  name = "aws-config-role"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "config.amazonaws.com"
          }
        },
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = aws_iam_role.config_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

resource "aws_config_configuration_recorder" "config_recorder" {
  name     = "day-30-aws-config-recoder"
  role_arn = aws_iam_role.config_role.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "delivery_channel" {
  name           = "day-30-aws-config-delivery-channel"
  s3_bucket_name = aws_s3_bucket.bucket.bucket
  depends_on     = [aws_config_configuration_recorder.config_recorder]
}

resource "aws_s3_bucket_policy" "aws_config_allow_policy" {
  bucket = aws_s3_bucket.bucket.id

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "s3:PutObject"
          Effect = "Allow"
          Principal = {
            Service = "config.amazonaws.com"
          }
          Resource = "${aws_s3_bucket.bucket.arn}/*"
        },
        {
          Action = "s3:GetBucketAcl"
          Effect = "Allow"
          Principal = {
            Service = "config.amazonaws.com"
          }
          Resource = "${aws_s3_bucket.bucket.arn}"
        }
      ]
    }
  )
}

resource "aws_config_config_rule" "ssh_config_rule" {
  name = "day-30-aws-ssh-config-rule"

  source {
    owner             = "AWS"
    source_identifier = "INCOMING_SSH_DISABLED"
  }

  depends_on = [aws_config_configuration_recorder.config_recorder]
}