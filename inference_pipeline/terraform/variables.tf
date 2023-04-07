variable "aws_region" {
  description = "The AWS region in which resource are deployed"
  default = "us-east-1"
}

variable "pipeline_name" {
  description = "The microservice name whose resources are being deployed"
  default = "inference_pipeline"
}
