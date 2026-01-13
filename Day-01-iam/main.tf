## Creating User 
resource "aws_iam_user" "readonly_user" {
  name = "terraform-readonly-user"
}

## Attaching Policy to the User
resource "aws_iam_user_policy_attachment" "ec2_readonly_policy" {
  user       = aws_iam_user.readonly_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

##Create Access Keys 
resource "aws_iam_access_key" "user_key" {
  user = aws_iam_user.readonly_user.name
}