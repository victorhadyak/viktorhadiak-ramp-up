# Define the Terraform module
module "my_lambda_function" {
  source = "git::https://github.com/victorhadyak/viktorhadiak-ramp-up/blob/main/API%20Integration%20task/Terraform"
  
  # Function configuration
  function_name     = "my-lambda-function"
  handler           = "lambda_function.lambda_handler"
  runtime           = "python3.9"
  source_code_hash  = "filebase64sha256("${path.module}/my-lambda-function.zip")"
  timeout           = 60
  memory_size       = 128
