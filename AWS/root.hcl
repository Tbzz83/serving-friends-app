generate "backend_config" {
  path = "backend_config.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "s3" {
    bucket = "friendsapp-backend-config"
    region = "us-east-2"
    key = "${path_relative_to_include()}/terraform.tfstate"
  }
}
EOF
}
