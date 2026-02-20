output "password" {
  value     = random_password.pass.result
  sensitive = true
}

output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "ID of the EC2 security group"
  value       = aws_security_group.ec2_sg.id
}

output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.ec2.id
}

output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.ec2.public_ip
}

output "secret_arn" {
  description = "ARN of the Secrets Manager secret"
  value       = aws_secretsmanager_secret.app_secret.arn
}

output "kms_key_arn" {
  description = "ARN of the KMS key used for encryption"
  value       = aws_kms_key.key.arn
}

output "iam_role_name" {
  description = "IAM Role attached to EC2"
  value       = aws_iam_role.ec2_role.name
}

output "instance_profile_name" {
  description = "Instance profile attached to EC2"
  value       = aws_iam_instance_profile.instance_profile.name
}