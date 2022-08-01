resource "aws_iam_role" "LambdaFullAccessRole" {
  name = "${var.project_name}_${var.stage_name}_LambdaFullAccessRole"
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

resource "aws_iam_role_policy" "allow_lambda" {
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "dynamodb:*",
          "ecs:*",
          "ecr:*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  })
  role = aws_iam_role.LambdaFullAccessRole.id
}

resource "aws_iam_role_policy_attachment" "ECSTaskExecutionRolePolicyAttachmentLambda" {
  role       = aws_iam_role.LambdaFullAccessRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
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
  function_name    = "${var.project_name}_${var.stage_name}_${var.lambda_get_details["function_name"]}"
  role             = aws_iam_role.LambdaFullAccessRole.arn
  handler          = var.lambda_get_details["handler"]
  source_code_hash = data.archive_file.lambda_get.output_base64sha256
  runtime          = "python3.9"
  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.model_registry.name,
      PRIMARY_KEY = aws_dynamodb_table.model_registry.hash_key
    }
  }
}

resource "aws_lambda_function" "lambda_post" {
  filename         = var.lambda_post_details["output_path"]
  function_name    = "${var.project_name}_${var.stage_name}_${var.lambda_post_details["function_name"]}"
  role             = aws_iam_role.LambdaFullAccessRole.arn
  handler          = var.lambda_post_details["handler"]
  source_code_hash = data.archive_file.lambda_post.output_base64sha256
  runtime          = "python3.9"
  environment {
    variables = {
      CLUSTER = aws_ecs_cluster.training_cluster.name,
      GROUP = aws_ecs_task_definition.training_task_definition.family,
      SUBNETS = var.default_subnets[0],
      SECURITY_GROUPS = var.security_groups[0],
      TASK_DEFINITION = "${var.project_name}_${var.stage_name}_training"
    }
  }
}
