output "bastion_public_ip" {
description = "Public IP of Bastion Host"
value       = aws_instance.baiston_host.public_ip
}

output "bastion_public_dns" {
description = "Public DNS of Bastion Host"
value       = aws_instance.baiston_host.public_dns
}

output "rds_endpoint" {
description = "RDS Endpoint"
value       = aws_db_instance.db.endpoint
}

output "rds_port" {
description = "RDS Port"
value       = aws_db_instance.db.port
}

output "db_name" {
description = "Database Name"
value       = aws_db_instance.db.db_name
}

output "vpc_id" {
description = "VPC ID"
value       = aws_vpc.vpc.id
}

output "public_subnet_id" {
description = "Public Subnet ID"
value       = aws_subnet.pub_subnet.id
}

output "private_subnet_1_id" {
description = "Private Subnet 1 ID"
value       = aws_subnet.subnet_1.id
}

output "private_subnet_2_id" {
description = "Private Subnet 2 ID"
value       = aws_subnet.subnet_2.id
}
