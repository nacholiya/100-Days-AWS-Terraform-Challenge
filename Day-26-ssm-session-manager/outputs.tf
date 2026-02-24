output "vpc_id" {
  value = aws_vpc.main.id
}

output "ec2_instance_id" {
  value = aws_instance.ec2_instance.id
}

output "ec2_private_ip" {
  value = aws_instance.ec2_instance.private_ip
}

output "ec2_public_ip" {
  value = aws_instance.ec2_instance.public_ip
}

output "ec2_iam_role_name" {
  value = aws_iam_role.ec2_role.name
}

output "ec2_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_instance_profile.name
}