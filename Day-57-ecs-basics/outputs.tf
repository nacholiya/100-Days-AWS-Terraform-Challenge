output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}

output "ecs_service_name" {
  value = aws_ecs_service.ecs_service.name
}

output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.ecs_task_defination.arn
}

output "security_group_id" {
  value = aws_security_group.ecs_sg.id
}

output "subnet_id" {
  value = aws_subnet.ecs_subnet.id
}