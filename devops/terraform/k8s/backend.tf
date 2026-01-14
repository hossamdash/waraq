# terraform {
#   backend "s3" {
#     bucket       = "waraq-terraform-state-eu-west-1"
#     key          = "k8s"
#     use_lockfile = true

#     profile = "localstack"
#     region  = "eu-west-1"

#     # LocalStack compatibility flags
#     endpoints = { s3 = "http://localhost:4566" }

#     skip_credentials_validation = true
#     skip_metadata_api_check     = true
#     skip_requesting_account_id  = true
#     skip_region_validation      = true
#     force_path_style            = true
#   }
# }
