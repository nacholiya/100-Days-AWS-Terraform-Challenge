resource "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/"
  output_path = "${path.module}/lambda/index.zip"
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "Day-53-lambda-exec-role"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "lambda.amazonaws.com"
          }
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachmenr" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "lambda_function" {
  function_name    = "Day-53-lambda-function"
  runtime          = "python3.11"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "index.lambda_handler"
  filename         = archive_file.lambda_zip.output_path
  source_code_hash = archive_file.lambda_zip.output_base64sha256
}

resource "aws_cloudwatch_event_rule" "schedule_rule" {
  name                = "Day-53-schedule-rule"
  description         = "A CloudWatch Event Rule to trigger Lambda every 5 minutes"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  target_id = "Day-53-lambda-target"
  rule      = aws_cloudwatch_event_rule.schedule_rule.name
  arn       = aws_lambda_function.lambda_function.arn
}

resource "aws_lambda_permission" "lambda_invoke_permission" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule_rule.arn
}