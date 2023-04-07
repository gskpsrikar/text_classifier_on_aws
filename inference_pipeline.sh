source ./config.sh

# Login to AWS
aws ecr get-login-password\
  --region ${REGION} | docker login \
  --username AWS \
  --password-stdin \
  ${IAM_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com

# cd into the inference pipeline folder
cd inference_pipeline

# Build docker image
docker build -t text_classifier_inference_image .
echo "Docker build step completed (either successfully/unsuccessfully)"
exit 1;
# Variables
ECR_REGISTRY_NAME="ml_image_repository"
ECR_REGISTRY=${IAM_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${ECR_REGISTRY_NAME}

# Docker tag
IMAGE_NAME="text_classifier_inference_image"
IMAGE_TAG="latest"
docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ECR_REGISTRY}:${IMAGE_NAME}

# Docker push
docker push ${ECR_REGISTRY}:${IMAGE_NAME}
echo "Docker push step completed (either successfully/unsuccessfully)"
