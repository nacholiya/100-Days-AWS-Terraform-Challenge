output "ec2_instance_1_public_ip" {
  description = "Public IP of EC2 instance 1"
  value       = aws_instance.ec2_instance.public_ip
}

output "ec2_instance_2_public_ip" {
  description = "Public IP of EC2 instance 2"
  value       = aws_instance.ec2_instance_2.public_ip
}

output "efs_id" {
  description = "ID of the EFS file system"
  value       = aws_efs_file_system.efs.id
}

output "efs_dns_name" {
  description = "DNS name of the EFS file system"
  value       = aws_efs_file_system.efs.dns_name
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_1_id" {
  description = "Public Subnet 1 ID"
  value       = aws_subnet.public_subnet_1.id
}

output "public_subnet_2_id" {
  description = "Public Subnet 2 ID"
  value       = aws_subnet.public_subnet_2.id
}