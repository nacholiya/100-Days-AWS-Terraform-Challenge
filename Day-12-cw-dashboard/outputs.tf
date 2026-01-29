## =====================
## EC2 Outputs
## =====================
output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.cloudwatch_ec2.id
}

output "ec2_public_ip" {
  description = "Public IP address of EC2 instance"
  value       = aws_instance.cloudwatch_ec2.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS name of EC2 instance"
  value       = aws_instance.cloudwatch_ec2.public_dns
}

## =====================
## Networking Outputs
## =====================
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.cloudwatch_vpc.id
}

output "public_subnet_id" {
  description = "Public subnet ID"
  value       = aws_subnet.public_subnet.id
}

output "security_group_id" {
  description = "EC2 Security Group ID"
  value       = aws_security_group.ec2_sg.id
}

## =====================
## Launch Template Outputs
## =====================
output "launch_template_id" {
  description = "Launch Template ID"
  value       = aws_launch_template.cloudwatch_lt.id
}

output "launch_template_latest_version" {
  description = "Latest launch template version"
  value       = aws_launch_template.cloudwatch_lt.latest_version
}

## =====================
## CloudWatch Outputs
## =====================
output "cloudwatch_dashboard_name" {
  description = "CloudWatch dashboard name"
  value       = aws_cloudwatch_dashboard.main.dashboard_name
}
