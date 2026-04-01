output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value = [
    aws_subnet.pb_subnet_1.id,
    aws_subnet.pb_subnet_2.id
  ]
}

output "alb_security_group_id" {
  description = "Security Group ID for ALB"
  value       = aws_security_group.alb_sg.id
}

output "ec2_security_group_id" {
  description = "Security Group ID for EC2"
  value       = aws_security_group.ec2_sg.id
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.alb.arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  description = "Hosted Zone ID of ALB (useful for Route53)"
  value       = aws_lb.alb.zone_id
}

output "target_group_arn" {
  description = "ARN of the Target Group"
  value       = aws_lb_target_group.app_tg.arn
}

output "ec2_instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.ec2.id
}

output "ec2_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.ec2.public_ip
}

output "acm_certificate_arn" {
  description = "ARN of imported ACM certificate"
  value       = aws_acm_certificate.import_cert.arn
}
