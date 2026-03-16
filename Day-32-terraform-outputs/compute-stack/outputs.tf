output "public_ip" {
  value       = aws_instance.tf-ec2.public_ip
  description = "Public IP address of the EC2 instance created by Terraform"
  sensitive   = true
}