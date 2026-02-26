output "guardduty_detector_id" {
  description = "ID of the GuardDuty detector"
  value       = aws_guardduty_detector.detector.id
}

output "guardduty_detector_status" {
  description = "Whether GuardDuty is enabled"
  value       = aws_guardduty_detector.detector.enable
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic for GuardDuty alerts"
  value       = aws_sns_topic.guardduty_alerts.arn
}

output "eventbridge_rule_name" {
  description = "Name of the EventBridge rule filtering GuardDuty findings"
  value       = aws_cloudwatch_event_rule.event_rule.name
}

output "eventbridge_rule_arn" {
  description = "ARN of the EventBridge rule"
  value       = aws_cloudwatch_event_rule.event_rule.arn
}

output "aws_account_id" {
  description = "AWS Account ID where GuardDuty is configured"
  value       = data.aws_caller_identity.current.account_id
}