provider "aws" {
  profile = "localstack"
  region  = var.region

  # LocalStack compatibility flags
  skip_credentials_validation = true
  skip_metadata_api_check     = true
}
