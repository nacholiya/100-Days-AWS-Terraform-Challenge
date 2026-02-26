resource "aws_guardduty_detector" "detector" {
  datasources {
    s3_logs {
      enable = true
    }
  }
  enable = true
}