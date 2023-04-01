# shellcheck disable=SC2164
#cd terraform
##terraform init
#terraform apply -target="aws_iam_role.AmazonECSTaskExecutionRole" -auto-approve
#terraform apply -target="aws_iam_role_policy_attachment.ECSTaskExecutionRolePolicyAttachment" -auto-approve
##terraform apply -target="aws_iam_role_policy_attachment.AWSVPCFullAccessPolicyAttachment" -auto-approve
#terraform apply -target="aws_iam_role_policy_attachment.ECRFullAccess" -auto-approve
#terraform apply -target="aws_ecs_cluster.training_cluster" -auto-approve
##terraform apply -target="aws_ecr_repository.admin_repository" -auto-approve
##terraform apply -target="aws_vpc.main" -auto-approve
##terraform apply -target="aws_subnet.main" -auto-approve
#terraform apply -target="aws_ecs_service.training_service" -auto-approve
#terraform apply -target="aws_ecs_task_definition.training_task_definition" -auto-approve
#cd ..

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 840807221296.dkr.ecr.us-east-1.amazonaws.com
docker build -t textClassifier_development_training_image docker_images
echo "docker build completed"
docker tag textClassifier_development_training_image:latest 840807221296.dkr.ecr.us-east-1.amazonaws.com/textclassifier_development_training_repository:textClassifier_development_training_image
docker push 840807221296.dkr.ecr.us-east-1.amazonaws.com/textclassifier_development_training_repository:textClassifier_development_training_image
echo "pushing completed"

#cd terraform
#terraform destroy -auto-approve
#terraform apply -target="aws_ecs_cluster.training_cluster" -auto-approve
#terraform apply -target="aws_iam_role.tf.fargate_ecr" -auto-approve
#terraform apply -target="aws_ecs_task_definition.task_definition" -auto-approve
#cd ..

#cd terraform
#terraform destroy -target="aws_ecs_cluster.training_cluster" -auto-approve
#terraform destroy -target="aws_iam_role.tf.fargate_ecr" -auto-approve
#terraform destroy -target="aws_ecs_task_definition.task_definition" -auto-approve
#cd ..