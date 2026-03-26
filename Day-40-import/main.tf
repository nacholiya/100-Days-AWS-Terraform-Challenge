resource "aws_s3_bucket" "my_bucket" {
  bucket = "nikhil-day40-import-demo-123"

  tags = {
    Name = "day-40-s3-bucket"
  }
}