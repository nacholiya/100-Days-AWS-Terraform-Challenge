resource "aws_ecr_repository" "ecr_repo" {
  name                 = "day-59-ecr"
  image_tag_mutability = "MUTABLE"
  #   force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}