provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "lambda_iam" {
  name = "lambda-iam"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          "Service" : "lambda.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

data "archive_file" "hello_world-zip" {
  type        = "zip"
  source_dir  = "./lambdas/hello_world/"
  output_path = "./lambdas/hello_world.zip"
}

resource "aws_lambda_function" "lambda_hello_world_v1_get" {
  filename         = "./lambdas/hello_world.zip"
  function_name    = "lambda_hello_world_v1_get"
  role             = aws_iam_role.lambda_iam.arn
  handler          = "hello_world_handler.lambda_handler"
  source_code_hash = data.archive_file.hello_world-zip.output_base64sha256
  runtime          = "python3.9"
}

resource "aws_lambda_function" "lambda_hello_world_v1_post" {
  filename         = "./lambdas/hello_world.zip"
  function_name    = "lambda_hello_world_v1_post"
  role             = aws_iam_role.lambda_iam.arn
  handler          = "hello_world_handler.lambda_handler"
  source_code_hash = data.archive_file.hello_world-zip.output_base64sha256
  runtime          = "python3.9"
}

resource "aws_api_gateway_rest_api" "hello_world_v1" {
  name = "hello_world_v1"
}

resource "aws_api_gateway_resource" "hello_world_v1" {
  parent_id   = aws_api_gateway_rest_api.hello_world_v1.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.hello_world_v1.id
  path_part = "test"
}

################################################################################
# GET method
################################################################################
resource "aws_api_gateway_method" "hello_world_v1_get" {
  rest_api_id   = aws_api_gateway_rest_api.hello_world_v1.id
  resource_id   = aws_api_gateway_resource.hello_world_v1.id
  http_method   = "GET"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "hello_world_v1_get" {
  rest_api_id = aws_api_gateway_rest_api.hello_world_v1.id
  resource_id = aws_api_gateway_method.hello_world_v1_get.resource_id
  http_method = aws_api_gateway_method.hello_world_v1_get.http_method
  integration_http_method = "GET"
  type = "AWS_PROXY"
  uri = aws_lambda_function.lambda_hello_world_v1_get.invoke_arn
}

################################################################################
# POST method
################################################################################
resource "aws_api_gateway_method" "hello_world_v1_post" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.hello_world_v1.id
  rest_api_id   = aws_api_gateway_rest_api.hello_world_v1.id
}
resource "aws_api_gateway_integration" "hello_world_v1_post" {
  rest_api_id = aws_api_gateway_rest_api.hello_world_v1.id
  resource_id = aws_api_gateway_method.hello_world_v1_post.resource_id
  http_method = aws_api_gateway_method.hello_world_v1_post.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.lambda_hello_world_v1_post.invoke_arn
}

resource "aws_lambda_permission" "get" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_hello_world_v1_get.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.hello_world_v1.execution_arn}/*/*"
}

resource "aws_lambda_permission" "post" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_hello_world_v1_post.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.hello_world_v1.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "hello_world_v1" {
  rest_api_id = aws_api_gateway_rest_api.hello_world_v1.id
  depends_on = [
    aws_api_gateway_method.hello_world_v1_get,
    aws_api_gateway_method.hello_world_v1_post
  ]
}

resource "aws_api_gateway_stage" "hello_world_v1" {
  deployment_id = aws_api_gateway_deployment.hello_world_v1.id
  rest_api_id   = aws_api_gateway_rest_api.hello_world_v1.id
  stage_name    = "development"
}

output "base_url" {
  value = aws_api_gateway_deployment.hello_world_v1.invoke_url
}
