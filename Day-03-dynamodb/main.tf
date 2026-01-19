resource "aws_dynamodb_table" "users" {
  name         = "tf-users-table"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "user_id"
  range_key = "created_at"

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "created_at"
    type = "S"
  }

  tags = {
    Project = "100DaysTerraform"
    Day     = "3"
  }
}