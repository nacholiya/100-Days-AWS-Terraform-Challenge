output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.alb.arn
}

output "alb_listener_arn" {
  description = "ARN of the ALB HTTP listener"
  value       = aws_lb_listener.alb_listener.arn
}

output "target_group_arns" {
  description = "ARNs of all target groups"
  value = {
    for k, tg in aws_lb_target_group.tg_alb :
    k => tg.arn
  }
}

output "ec2_instance_ids" {
  description = "EC2 instance IDs"
  value = {
    for k, ec2 in aws_instance.ec2 :
    k => ec2.id
  }
}

output "ec2_public_ips" {
  description = "Public IPs of EC2 instances"
  value = {
    for k, ec2 in aws_instance.ec2 :
    k => ec2.public_ip
  }
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = values(aws_subnet.public)[*].id
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "alb_dns_name" {
  description = "DNS name of ALB"
  value       = aws_lb.alb.dns_name
}