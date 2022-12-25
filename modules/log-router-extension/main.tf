locals {
  extension_name = "log-router-kinesis"
}

data "archive_file" "package" {
  type        = "zip"
  source_dir  = "${var.extension_base_path}/src/log-router-kinesis/target/lambda/"
  output_path = "temp/${local.extension_name}.zip"
}


resource "aws_lambda_layer_version" "lambda_extension" {
  filename         = "temp/${local.extension_name}.zip"
  layer_name       = local.extension_name
  source_code_hash = data.archive_file.package.output_base64sha256

  compatible_runtimes = ["nodejs16.x", "nodejs18.x", "provided.al2"]
}