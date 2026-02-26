data "aws_caller_identity" "current" {

}

resource "aws_cloudwatch_event_rule" "event_rule" {
  name = "guardduty-event-rule"
  event_pattern = jsonencode({
    "source"      = ["aws.guardduty"]
    "detail-type" = ["GuardDuty Finding"]
    "detail" = {
      "severity" = [{
        "numeric" = [">=", 7]
      }]
    }
  })

}

resource "aws_cloudwatch_event_target" "event_target" {
  rule      = aws_cloudwatch_event_rule.event_rule.name
  arn       = aws_sns_topic.guardduty_alerts.arn
  target_id = "day-28-${data.aws_caller_identity.current.account_id}"
}

resource "aws_sns_topic_policy" "policy" {
  arn = aws_sns_topic.guardduty_alerts.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sns:Publish"
        ]
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Resource = aws_sns_topic.guardduty_alerts.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_cloudwatch_event_rule.event_rule.arn
          }
        }
      }
    ]
  })
}