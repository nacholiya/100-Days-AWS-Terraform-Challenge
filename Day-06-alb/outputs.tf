##Public DNS of ALB
output "alb_dns_name" {
  description = "Public DNS name of the Application Load Balancer"
  value       = aws_lb.tf_alb.dns_name
}

##EC2 Instance ids
output "ec2_instance_ids" {
  description = "EC2 instance IDs behind the ALB"
  value       = [for instance in aws_instance.tf_ec2 : instance.id]
}

##Target Group ARN
output "target_group_arn" {
  description = "Target Group ARN"
  value       = aws_lb_target_group.tf_tg.arn
}