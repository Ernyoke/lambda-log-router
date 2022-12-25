locals {
  function_name = "log-router-test"
}

resource "aws_lambda_function" "lambda" {
  function_name    = local.function_name
  handler          = "index.handler"
  memory_size      = 128
  package_type     = "Zip"
  role             = aws_iam_role.lambda_role.arn
  runtime          = "nodejs18.x"
  filename         = "${path.module}/temp/${local.function_name}.zip"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  timeout          = 60
  architectures    = ["x86_64"]

  environment {
    variables = {
      KINESIS_DELIVERY_STREAM = var.stream_name
    }
  }

  layers = [
    var.extension_arn
  ]
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${var.lambda_base_path}/src/test-lambda"
  output_path = "${path.module}/temp/${local.function_name}.zip"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  name               = "${local.function_name}-role"
}

resource "aws_iam_role_policy_attachment" "basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy_attachment" "kinesis_execution" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisFirehoseFullAccess"
  role       = aws_iam_role.lambda_role.name
}

resource "aws_lambda_function_url" "lambda_url" {
  function_name      = aws_lambda_function.lambda.function_name
  authorization_type = "NONE"
}
