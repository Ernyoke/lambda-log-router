output "lambda_url" {
  description = "Invoke the lambda function using the following url:"
  value       = aws_lambda_function_url.lambda_url.function_url
}