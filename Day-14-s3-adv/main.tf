##S3 Bucket for IAM Testing
resource "aws_s3_bucket" "restricted_bucket" {
  bucket = "day14-iam-restricted-bucket-12345"

  tags = {
    Name = "day14-iam-restricted-bucket12345"
    Env  = "Learning"
  }
}

##IAM Policy: Restrict access to ONE S3 Bucket only
resource "aws_iam_policy" "restricted_bucket_policy" {
  name        = "day14-s3-restricted-policy"
  description = "Allow EC2 access to only one specific S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = aws_s3_bucket.restricted_bucket.arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.restricted_bucket.arn}/*"
      }
    ]
  })
}

## Creating IAM Role for EC2 Instance
resource "aws_iam_role" "ec2_role" {
  name = "day14-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

##Attach Policy to EC2 Role
resource "aws_iam_role_policy_attachment" "attach_restricted_bucket_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.restricted_bucket_policy.arn
}