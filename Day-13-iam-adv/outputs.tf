## =====================
## EC2 Outputs
## =====================
output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.iam_ec2.id
}

output "ec2_public_ip" {
  description = "Public IP address of EC2"
  value       = aws_instance.iam_ec2.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS of EC2"
  value       = aws_instance.iam_ec2.public_dns
}

## =====================
## IAM Outputs
## =====================
output "iam_role_name" {
  description = "IAM role attached to EC2"
  value       = aws_iam_role.ec2_role.name
}

output "iam_instance_profile_name" {
  description = "Instance profile used by EC2"
  value       = aws_iam_instance_profile.ec2_profile.name
}

output "iam_policy_arn" {
  description = "S3 read-only IAM policy ARN"
  value       = aws_iam_policy.s3_read_only.arn
}

## =====================
## Networking Outputs
## =====================
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.iam_vpc.id
}

output "public_subnet_id" {
  description = "Public subnet ID"
  value       = aws_subnet.public_subnet.id
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.ec2_sg.id
}

## =====================
## Launch Template
## =====================
output "launch_template_id" {
  description = "Launch Template ID"
  value       = aws_launch_template.iam_lt.id
}

output "launch_template_latest_version" {
  description = "Latest Launch Template version"
  value       = aws_launch_template.iam_lt.latest_version
}