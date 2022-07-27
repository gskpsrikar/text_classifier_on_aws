################################################################################
# REST API and Resource
################################################################################
resource "aws_api_gateway_rest_api" "text_classifier_rest_api" {
  name = var.api_gateway_rest_api_name
}

resource "aws_api_gateway_resource" "text_classifier_resource" {
  parent_id   = aws_api_gateway_rest_api.text_classifier_rest_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.text_classifier_rest_api.id
  path_part = var.resource_path
}

################################################################################
# GET method and integration
################################################################################
resource "aws_api_gateway_method" "text_classifier_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.text_classifier_rest_api.id
  resource_id   = aws_api_gateway_resource.text_classifier_resource.id
  http_method   = "GET"
  authorization = "NONE"

}
resource "aws_api_gateway_integration" "text_classifier_get_integration" {
  rest_api_id = aws_api_gateway_rest_api.text_classifier_rest_api.id
  resource_id = aws_api_gateway_method.text_classifier_get_method.resource_id
  http_method = aws_api_gateway_method.text_classifier_get_method.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.lambda_get.invoke_arn
}

################################################################################
# POST method and integration
################################################################################
resource "aws_api_gateway_method" "text_classifier_post_method" {
  rest_api_id   = aws_api_gateway_rest_api.text_classifier_rest_api.id
  resource_id   = aws_api_gateway_resource.text_classifier_resource.id
  http_method   = "POST"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "text_classifier_post_integration" {
  rest_api_id = aws_api_gateway_rest_api.text_classifier_rest_api.id
  resource_id = aws_api_gateway_method.text_classifier_post_method.resource_id
  http_method = aws_api_gateway_method.text_classifier_post_method.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.lambda_post.invoke_arn
}

################################################################################
# AWS Lambda Permission
################################################################################
resource "aws_lambda_permission" "text_classifier_lambda_get_permission" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_get.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.text_classifier_rest_api.execution_arn}/*"
}

resource "aws_lambda_permission" "text_classifier_lambda_post_permission" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_post.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.text_classifier_rest_api.execution_arn}/*"
}

################################################################################
# Stage and Deployment
################################################################################
resource "aws_api_gateway_deployment" "text_classifier_deployment" {
  rest_api_id = aws_api_gateway_rest_api.text_classifier_rest_api.id
  depends_on = [
    aws_api_gateway_integration.text_classifier_get_integration,
    aws_api_gateway_integration.text_classifier_post_integration
  ]
}

resource "aws_api_gateway_stage" "text_classifier_stage" {
  deployment_id = aws_api_gateway_deployment.text_classifier_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.text_classifier_rest_api.id
  stage_name    = var.stage_name
}

################################################################################
# Outputs
################################################################################
output "base_url" {
  value = aws_api_gateway_deployment.text_classifier_deployment.invoke_url
}
