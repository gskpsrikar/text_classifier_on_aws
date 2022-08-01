resource "aws_dynamodb_table" "model_registry" {
  hash_key = "model_name"
  name = "${var.project_name}_${var.stage_name}_${var.dynamodb_model_registry}"
  read_capacity = 5
  write_capacity = 5
  attribute {
    name = "model_name"
    type = "S"
  }
}

//################################################################################
//# DEPRECATED - Declaring variables and creating S3 bucket, DynamoDB
//################################################################################
//# S3 Related Configuration
//resource "aws_s3_bucket" "CustomTrainedModelArtifactsS3Bucket" {
//  bucket = var.custom_trained_model_artifacts_s3_bucket
//  acl = "private"
//  force_destroy = true
//}
//resource "aws_s3_bucket_public_access_block" "BlockS3PublicAccess" {
//  bucket = aws_s3_bucket.CustomTrainedModelArtifactsS3Bucket.id
//}
//
//# DynamoDB related Configuration
