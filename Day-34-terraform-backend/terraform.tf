terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  #   backend "s3" {
  #     bucket         = "terraform-day-34-state-bucket-1808-nacholiya"
  #     key            = "terraform.tfstate"
  #     region         = "ap-south-1"
  #     dynamodb_table = "day-34-state-lock-table"
  #   }
}