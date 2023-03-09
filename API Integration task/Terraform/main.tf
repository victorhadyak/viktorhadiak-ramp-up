# Define the Terraform module
module "my_lambda_function" {
  source = "git::https://github.com/my-github-account/my-lambda-function//terraform/modules/lambda_function"
  
  # Function configuration
  function_name     = "my-lambda-function"
  handler           = "lambda_function.lambda_handler"
  runtime           = "python3.9"
  source_code_hash  = "filebase64sha256("${path.module}/my-lambda-function.zip")"
  timeout           = 60
  memory_size       = 128
