# ------------------------
# Backup Outputs
# ------------------------

output "backup_vault_name" {
  description = "Name of the AWS Backup Vault"
  value       = aws_backup_vault.backup_vault.name
}

output "backup_plan_id" {
  description = "ID of the AWS Backup Plan"
  value       = aws_backup_plan.backup_plan.id
}

output "backup_selection_id" {
  description = "ID of the Backup Selection"
  value       = aws_backup_selection.backup_slection.id
}

output "backup_iam_role_arn" {
  description = "IAM Role ARN used by AWS Backup"
  value       = aws_iam_role.backup_role.arn
}

# ------------------------
# EC2 Outputs
# ------------------------

output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.ec2.id
}

output "ec2_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.ec2.public_ip
}

output "ec2_private_ip" {
  description = "Private IP of EC2 instance"
  value       = aws_instance.ec2.private_ip
}

# ------------------------
# Networking Outputs
# ------------------------

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.ec2-sg.id
}