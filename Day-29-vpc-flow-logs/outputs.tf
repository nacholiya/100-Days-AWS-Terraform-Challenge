output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "ec2_public_ip" {
  value = aws_instance.ec2.public_ip
}

output "ec2_instance_id" {
  value = aws_instance.ec2.id
}

output "flow_log_id" {
  value = aws_flow_log.flow_logs.id
}

output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.vpc_flow_logs.name
}