output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.tf_ec2.id
}

output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.tf_ec2.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.tf_ec2.public_dns
}

output "ebs_volume_id" {
  description = "Attached EBS volume ID"
  value       = aws_ebs_volume.tf_ec2_data_volume.id
}
