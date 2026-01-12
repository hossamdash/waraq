provider "aws" {
  profile = "localstack"
  region  = var.region

  # LocalStack compatibility flags
  s3_use_path_style           = false
  skip_credentials_validation = true
  skip_requesting_account_id  = false
  skip_metadata_api_check     = true

  endpoints {
    s3        = "http://s3.localhost.localstack.cloud:4566"
    s3control = "http://localhost.localstack.cloud:4566"
  }
}
