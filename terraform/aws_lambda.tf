resource "aws_iam_role" "LambdaDynamoDBFullAccessRole" {
  name = "LambdaDynamoDBFullAccessRole"
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

resource "aws_iam_role_policy" "dynamo_allow" {
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "dynamodb:*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  })
  role = aws_iam_role.LambdaDynamoDBFullAccessRole.id
}

//resource "null_resource" "install_python_dependencies_1" {
//  provisioner "local-exec" {
//    command = "bash ../scripts/dependencies.sh" # var.path_source_code
//
//    environment = {
//      source_code_path = "lambdas/get_model_details" # var.path_source_code
//      function_name = "lambda_hello_world_v1_get" # var.function_name
//      path_module = path.module
//      runtime = "python3.9"
//      path_cwd = path.cwd
//    }
//  }
//}

//resource "null_resource" "install_python_dependencies_2" {
//  provisioner "local-exec" {
//    command = "bash ../scripts/dependencies.sh" # var.path_source_code
//
//    environment = {
//      source_code_path = "lambdas/get_model_details" # var.path_source_code
//      function_name = "lambda_hello_world_v1_post" # var.function_name
//      path_module = path.module
//      runtime = "python3.9"
//      path_cwd = path.cwd
//    }
//  }
//}
################################################################################
# Lambdas
################################################################################
data "archive_file" "lambda_get" {
  type        = "zip"
  source_dir  = var.lambda_get_details["source_dir"]
  output_path = var.lambda_get_details["output_path"]
}

data "archive_file" "lambda_post" {
  type        = "zip"
  source_dir  = var.lambda_post_details["source_dir"]
  output_path = var.lambda_post_details["output_path"]
}

resource "aws_lambda_function" "lambda_get" {
  filename         = var.lambda_get_details["output_path"]
  function_name    = "${var.application_name}_${var.stage_name}_${var.lambda_get_details["function_name"]}"
  role             = aws_iam_role.LambdaDynamoDBFullAccessRole.arn
  handler          = var.lambda_get_details["handler"]
  source_code_hash = data.archive_file.lambda_get.output_base64sha256
  runtime          = "python3.9"
//  depends_on = [null_resource.install_python_dependencies_1]
}

resource "aws_lambda_function" "lambda_post" {
  filename         = var.lambda_post_details["output_path"]
  function_name    = "${var.application_name}_${var.stage_name}_${var.lambda_post_details["function_name"]}"
  role             = aws_iam_role.LambdaDynamoDBFullAccessRole.arn
  handler          = var.lambda_post_details["handler"]
  source_code_hash = data.archive_file.lambda_post.output_base64sha256
  runtime          = "python3.9"
//  depends_on = [null_resource.install_python_dependencies_2]
}
