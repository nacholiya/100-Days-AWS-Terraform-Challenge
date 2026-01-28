## EC2 Outputs
output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.cloudwatch_ec2.id
}

output "ec2_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.cloudwatch_ec2.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS of EC2 instance"
  value       = aws_instance.cloudwatch_ec2.public_dns
}

## Launch Template
output "launch_template_id" {
  description = "Launch Template ID"
  value       = aws_launch_template.cloudwatch_lt.id
}

output "launch_template_latest_version" {
  description = "Latest Launch Template version"
  value       = aws_launch_template.cloudwatch_lt.latest_version
}

## Networking Outputs
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

## CloudWatch Outputs
output "cloudwatch_alarm_name" {
  description = "CloudWatch CPU alarm name"
  value       = aws_cloudwatch_metric_alarm.high_cpu.alarm_name
}

## SNS Outputs
output "sns_topic_arn" {
  description = "SNS topic ARN for alerts"
  value       = aws_sns_topic.alerts.arn
}

output "sns_subscription_endpoint" {
  description = "SNS email subscription endpoint"
  value       = aws_sns_topic_subscription.email_alert.endpoint
}
