include {
  path = find_in_parent_folders()
}

dependency "lambda_extension" {
  config_path = "..//lambda-extension"
}

terraform {
  source = "../../modules//lambda"
}

inputs = {
  extension_arn    = dependency.lambda_extension.outputs.extension_arn
  lambda_base_path = "${find_in_parent_folders("root.hcl")}/../"
}