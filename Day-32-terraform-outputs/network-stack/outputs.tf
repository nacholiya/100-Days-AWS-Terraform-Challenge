output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID of the VPC created for the Day 32 infrastructure"
}

output "public_subnet_id" {
  value       = aws_subnet.public.id
  description = "ID of the public subnet where the EC2 instance is deployed"
}

# output "sg_id" {
#   value       = aws_security_group.tf-sg.id
#   description = "ID of the security group attached to the EC2 instance"
# }