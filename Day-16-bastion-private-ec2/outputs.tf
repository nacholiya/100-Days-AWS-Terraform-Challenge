output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "Public subnet ID (Bastion)"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "Private subnet ID (Private EC2)"
  value       = aws_subnet.private.id
}

output "bastion_public_ip" {
  description = "Public IP of Bastion host"
  value       = aws_instance.bastion.public_ip
}

output "private_ec2_private_ip" {
  description = "Private IP of private EC2"
  value       = aws_instance.private_ec2.private_ip
}

output "bastion_security_group_id" {
  description = "Security group ID for Bastion"
  value       = aws_security_group.bastion_sg.id
}

output "private_ec2_security_group_id" {
  description = "Security group ID for Private EC2"
  value       = aws_security_group.private_ec2_sg.id
}
