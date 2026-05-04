output "api_url" {
  value       = "https://${aws_api_gateway_rest_api.rest_api.id}.execute-api.ap-south-1.amazonaws.com/${aws_api_gateway_stage.api_stage.stage_name}/${aws_api_gateway_resource.lambda_resource.path_part}"
  description = "The URL of the API Gateway endpoint"
}