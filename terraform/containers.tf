resource "aws_iam_role" "AmazonECSTaskExecutionRole" {
  name = "${var.project_name}_${var.stage_name}_AmazonECSTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          "Service" : ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
        }
        Effect : "Allow"
        Sid = ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ECSTaskExecutionRolePolicyAttachment" {
  role       = aws_iam_role.AmazonECSTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
resource "aws_iam_role_policy_attachment" "ECRFullAccess" {
  role       = aws_iam_role.AmazonECSTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_ecr_repository" "admin_repository" {
  name = "textclassifier_development_training_repository"
  force_delete = true
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name = "${var.project_name}_${var.stage_name}"
  tags = {
    Environment = var.stage_name
    Application = var.project_name
  }
}

resource "aws_ecs_task_definition" "training_task_definition" {
  family = "${var.project_name}_${var.stage_name}_training"
  network_mode = "awsvpc"
  task_role_arn = aws_iam_role.AmazonECSTaskExecutionRole.arn
  execution_role_arn = aws_iam_role.AmazonECSTaskExecutionRole.arn
  requires_compatibilities = ["FARGATE"]
  memory = 512
  cpu = 256
  container_definitions = jsonencode([
    {
      name = "${var.project_name}_${var.stage_name}_training_task_container"
      image = "${var.account_id}.dkr.ecr.us-east-1.amazonaws.com/${aws_ecr_repository.admin_repository.name}:textClassifier_development_training_image"
      logConfiguration: {
      logDriver: "awslogs",
      options: {
        awslogs-group: aws_cloudwatch_log_group.cloudwatch_log_group.name,
        awslogs-region: var.region_name,
        awslogs-stream-prefix: "containerLogs"
      }
    }
    }
  ])
}

resource "aws_ecs_cluster" "training_cluster" {
  name = "${var.project_name}_${var.stage_name}_cluster"
}

resource "aws_ecs_service" "training_service" {
  name            = "${var.project_name}_${var.stage_name}_service"
  cluster         = aws_ecs_cluster.training_cluster.id
  task_definition = aws_ecs_task_definition.training_task_definition.arn
  desired_count   = 3
  network_configuration {
    subnets = var.default_subnets
  }
}
