# ----------------------------
# VPC
# ----------------------------

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

# ----------------------------
# ALB
# ----------------------------

output "alb_arn" {
  description = "Application Load Balancer ARN"
  value       = aws_lb.app_alb.arn
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS Name"
  value       = aws_lb.app_alb.dns_name
}

output "alb_zone_id" {
  description = "ALB Hosted Zone ID (used for Route53 alias)"
  value       = aws_lb.app_alb.zone_id
}

# ----------------------------
# Target Group
# ----------------------------

output "target_group_arn" {
  description = "Target Group ARN"
  value       = aws_lb_target_group.app_tg.arn
}

# ----------------------------
# Route 53
# ----------------------------

output "route53_zone_id" {
  description = "Route53 Hosted Zone ID"
  value       = aws_route53_zone.day19_zone.zone_id
}

output "route53_zone_name_servers" {
  description = "Route53 Name Servers"
  value       = aws_route53_zone.day19_zone.name_servers
}

output "app_domain_name" {
  description = "Application DNS name created in Route53"
  value       = aws_route53_record.app_alias.fqdn
}