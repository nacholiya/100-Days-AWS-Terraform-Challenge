output "invoke_url" {
  value = "https://${aws_api_gateway_rest_api.rest_api.id}.execute-api.us-east-1.amazonaws.com/dev/hello"
}