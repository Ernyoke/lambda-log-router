include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules//log-router-extension"
}

inputs = {
  extension_base_path = "${find_in_parent_folders("root.hcl")}/../"
}

