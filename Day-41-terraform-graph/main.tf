resource "aws_s3_bucket" "bucket" {
  bucket = "day-41-s3-bucket-nacholiya-1808"

  tags = {
    Name = "day-41-s3-bucket"
  }
}


## IMPLICIT DEPENDENCY
resource "aws_s3_object" "object" {
  bucket     = aws_s3_bucket.bucket.id
  key        = "OBJ-1"
  depends_on = [null_resource.setup]

  tags = {
    Name = "day-41-s3-bucket-object"
  }
}

## EXPLICIT DEPENDENCY
resource "null_resource" "setup" {
}