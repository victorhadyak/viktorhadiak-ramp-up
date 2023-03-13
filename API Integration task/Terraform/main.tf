# Define a zip archive file from source directory and save to output directory
data "archive_file" "lambda_function_zip" {
  type        = "zip"
  output_path = var.output_dir
}

# Define IAM role for Lambda execution with policy attachment
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"
  assume_role_policy = var.add_policy
}

# Attach policy for Lambda execution to IAM role
resource "aws_iam_role_policy_attachment" "lambda_logs_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_execution_role.name
}

# Define Lambda function
resource "aws_lambda_function" "my_lambda_function" {
  filename         = "jira_webex_lambda_function.zip"
  function_name    = "my-lambda-function"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  memory_size      = 128
  timeout          = 60
  source_code_hash = data.archive_file.lambda_function_zip.output_base64sha256    
}      

# Define an event source mapping
resource "aws_lambda_event_source_mapping" "test_event" {
  event_source_arn  = aws_api_gateway_rest_api.my_api.execution_arn
  function_name     = aws_lambda_function.my_lambda_function.function_name
  starting_position = "LATEST"
  batch_size        = 1
  enabled           = true
  maximum_batching_window_in_seconds = 0
    event = var.test_event
}
 
# Define an API Gateway
resource "aws_api_gateway_rest_api" "my_api" {
  name = "my-api"
}

# Define a resource within the API Gateway
resource "aws_api_gateway_resource" "my_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "my-resource"
}

# Define a method within the API Gateway
resource "aws_api_gateway_method" "my_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.my_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

# Define an integration between the API Gateway and the Lambda function
resource "aws_api_gateway_integration" "my_integration" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.my_resource.id
  http_method = aws_api_gateway_method.my_method.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri  = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.my_lambda_function.arn}/invocations"
}

# Define a permission for the API Gateway to invoke the Lambda function
resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.my_api.id}/*/POST/my-resource"
}
