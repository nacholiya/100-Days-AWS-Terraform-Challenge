resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"
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

resource "aws_iam_role_policy_attachment" "lambda_execution_role_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda_zip1" {
  type        = "zip"
  source_file = "${path.module}/lambda/step1_lambda.py"
  output_path = "${path.module}/lambda/step1_lambda.zip"
}

data "archive_file" "lambda_zip2" {
  type        = "zip"
  source_file = "${path.module}/lambda/step2_lambda.py"
  output_path = "${path.module}/lambda/step2_lambda.zip"
}

resource "aws_lambda_function" "step1_lambda" {
  function_name    = "step1_lambda"
  runtime          = "python3.11"
  handler          = "step1_lambda.lambda_handler"
  role             = aws_iam_role.lambda_execution_role.arn
  filename         = data.archive_file.lambda_zip1.output_path
  source_code_hash = data.archive_file.lambda_zip1.output_base64sha256
}

resource "aws_lambda_function" "step2_lambda" {
  function_name    = "step2_lambda"
  runtime          = "python3.11"
  handler          = "step2_lambda.lambda_handler"
  role             = aws_iam_role.lambda_execution_role.arn
  filename         = data.archive_file.lambda_zip2.output_path
  source_code_hash = data.archive_file.lambda_zip2.output_base64sha256
}

resource "aws_iam_role" "step_function_role" {
  name = "step-function-role"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "states.amazonaws.com"
          }
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "policy_role" {
  name = "policy-for-steo-function-role"
  role = aws_iam_role.step_function_role.id

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "lambda:InvokeFunction"
          Effect = "Allow"
          Resource = [
            aws_lambda_function.step1_lambda.arn,
            aws_lambda_function.step2_lambda.arn
          ]
        }
      ]
    }
  )
}

resource "aws_sfn_state_machine" "lambda_sfn_machine" {
  name     = "Day-56-step-function-state-machine"
  role_arn = aws_iam_role.step_function_role.arn

  definition = <<EOF
  {
    "StartAt": "Step1",
    "States": {
      "Step1": {
        "Type": "Task",
        "Resource": "${aws_lambda_function.step1_lambda.arn}",
        "Next": "Step2"
      },
      "Step2": {
        "Type": "Task",
        "Resource": "${aws_lambda_function.step2_lambda.arn}",
        "End": true
      }
    }
  }
  EOF
}