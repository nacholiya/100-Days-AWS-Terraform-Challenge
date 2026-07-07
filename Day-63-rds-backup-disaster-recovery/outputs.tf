output "bastion_public_ip" {
  description = "Public IP of the Bastion Host"
  value       = aws_instance.bastion_host.public_ip
}

output "bastion_public_dns" {
  description = "Public DNS of the Bastion Host"
  value       = aws_instance.bastion_host.public_dns
}

output "rds_endpoint" {
  description = "RDS Endpoint"
  value       = aws_db_instance.db.endpoint
}

output "rds_address" {
  description = "RDS Address"
  value       = aws_db_instance.db.address
}

output "rds_port" {
  description = "RDS Port"
  value       = aws_db_instance.db.port
}

output "rds_database_name" {
  description = "Database Name"
  value       = aws_db_instance.db.db_name
}

output "rds_username" {
  description = "Master Username"
  value       = aws_db_instance.db.username
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
}

output "db_subnet_group" {
  description = "DB Subnet Group"
  value       = aws_db_subnet_group.db_subnet_group.name
}