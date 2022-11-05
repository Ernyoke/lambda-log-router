locals {
  extension_name = "log-rouer-kinesis"
}

data "archive_file" "package" {
  type        = "zip"
  source_dir  = "${var.extension_base_path}/src/log-router-kinesis/target/lambda/"
  output_path = "temp/${local.extension_name}.zip"
}


resource "aws_lambda_layer_version" "lambda_extension" {
  filename   = "temp/${local.extension_name}.zip"
  layer_name = local.extension_name

  compatible_runtimes = ["nodejs14.x", "provided.al2"]
}