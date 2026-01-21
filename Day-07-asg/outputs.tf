##ALB DNS Name
output "alb_dns_name" {
  description = "Public DNS name of the Application Load Balancer"
  value       = aws_lb.tf_asg_alb.dns_name
}

##Auto Scaling group Name
output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.tf_asg.name
}

##Target Group ARN
output "tg_arn" {
  description = "ARN of the ALB Target Group"
  value       = aws_lb_target_group.tf_alb_tg.arn
}

##VPC ID
output "vpc_id" {
  description = "VPC ID where resources are deployed"
  value       = aws_vpc.tf_vpc.id
}

##Public Subnet IDs
output "pb_subnet_id" {
  description = "IDs of public subnets used by ALB and ASG"
  value       = [for subnet in aws_subnet.tf_subnets : subnet.id]
}