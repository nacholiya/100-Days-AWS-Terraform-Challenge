output "ec2_public_ip" {
  value = aws_instance.ec2.public_ip
}

output "ssm_string_parameter_name" {
  value = aws_ssm_parameter.foo.name
}

output "ssm_secure_parameter_name" {
  value = aws_ssm_parameter.too.name
}

output "kms_key_arn" {
  value = aws_kms_key.key.arn
}

output "iam_role_name" {
  value = aws_iam_role.ec2.name
}