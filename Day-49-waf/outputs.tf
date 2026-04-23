output "awf_arn" {
  description = "ARN for WAF Web ACL"
  value       = aws_wafv2_web_acl.web_acl.arn
}