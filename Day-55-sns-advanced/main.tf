resource "aws_sns_topic" "my_topic" {
  name = "Day-55-SNS-Topic"
}

resource "aws_sqs_queue" "my_queue" {
  name                       = "Day-55-SQS-Queue"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600
}

resource "aws_sns_topic_subscription" "my_subscription" {
  topic_arn = aws_sns_topic.my_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.my_queue.arn
}

resource "aws_sns_topic_subscription" "my_subscription_email" {
  topic_arn = aws_sns_topic.my_topic.arn
  protocol  = "email"
  endpoint  = "i.nikhil8088@gmail.com"
}

data "aws_iam_policy_document" "sns_sqs_policy" {
  statement {
    actions = [
      "sqs:SendMessage"
    ]

    resources = [
      aws_sqs_queue.my_queue.arn
    ]

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.my_topic.arn]
    }
  }
}

resource "aws_sqs_queue_policy" "my_queue_policy" {
  queue_url = aws_sqs_queue.my_queue.id
  policy    = data.aws_iam_policy_document.sns_sqs_policy.json
}