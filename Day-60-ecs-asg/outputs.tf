# VPC Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
}

# ECS Outputs
output "ecs_cluster_name" {
  description = "ECS Cluster Name"
  value       = aws_ecs_cluster.ecs.name
}

output "ecs_service_name" {
  description = "ECS Service Name"
  value       = aws_ecs_service.ecs_service.name
}

output "ecs_task_definition_arn" {
  description = "ECS Task Definition ARN"
  value       = aws_ecs_task_definition.task_definition.arn
}

# ECR Output
output "ecr_repository_url" {
  description = "ECR Repository URL"
  value       = aws_ecr_repository.ecr_repo.repository_url
}

# Load Balancer Outputs
output "alb_dns_name" {
  description = "Application Load Balancer DNS Name"
  value       = aws_lb.ecs_alb.dns_name
}

output "alb_arn" {
  description = "Application Load Balancer ARN"
  value       = aws_lb.ecs_alb.arn
}

# Target Group Output
output "target_group_arn" {
  description = "ALB Target Group ARN"
  value       = aws_lb_target_group.ecs_alb_tg.arn
}

# CloudWatch Logs
output "cloudwatch_log_group" {
  description = "CloudWatch Log Group Name"
  value       = aws_cloudwatch_log_group.cw_log_grp.name
}

# Auto Scaling Outputs
output "autoscaling_target_resource_id" {
  description = "Application Auto Scaling Target Resource ID"
  value       = aws_appautoscaling_target.ecs_ast.resource_id
}

output "autoscaling_policy_name" {
  description = "Application Auto Scaling Policy Name"
  value       = aws_appautoscaling_policy.ecs_asp.name
}