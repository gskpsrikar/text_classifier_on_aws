# .tf is a mandatory file extension
################################ PROVIDER ################################
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}


################################ VARIABLES ################################

variable "custom_trained_model_registry_table_name" {
  type = string
  description = "Table name for storing custom trained ML models"
}

variable "custom_trained_model_artifacts_s3_bucket" {
  type = string
  description = "S3 bucket where all the model files are stored"
}


# S3 Related Configuration
resource "aws_s3_bucket" "CustomTrainedModelArtifactsS3Bucket" {
  bucket = var.custom_trained_model_artifacts_s3_bucket
  acl = "private"
  force_destroy = true
}
resource "aws_s3_bucket_public_access_block" "BlockS3PublicAccess" {
  bucket = aws_s3_bucket.CustomTrainedModelArtifactsS3Bucket.id
}

# DynamoDB related Configuration
resource "aws_dynamodb_table" "CustomTrainedModelRegistry" {
  hash_key = "model_name"
  name = var.custom_trained_model_registry_table_name
  read_capacity = 5
  write_capacity = 5
  attribute {
    name = "model_name"
    type = "S"
  }
}