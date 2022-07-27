variable "application_name" {
  type = string
  default = "textClassifier"
}

variable "resource_path" {
  type = string
  default = "tc"
}
variable "stage_name" {
  type = string
  default = "development"
}

variable "lambda_get_details" {
  type = map
  default = {
    function_name = "model_get", # name of aws_lambda_function.lambda_get
    source_dir = "../lambdas/get_model_details/", # source_dir of data.archive_file
    output_path = "../lambdas/get_model_details.zip" # output_path of data.archive_file
    handler = "app.lambda_handler"
  }
}

variable "lambda_post_details" {
  type = map
  default = {
    function_name = "model_post", # name of aws_lambda_function.lambda_post
    source_dir = "../lambdas/train_model/", # source_dir of data.archive_file
    output_path = "../lambdas/train_model.zip" # output_path of data.archive_file
    handler = "app.lambda_handler"
  }
}

variable "api_gateway_rest_api_name" {
  type = string
  default = "textClassifier_rest_api"
}
