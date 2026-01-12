terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  profile = "localstack"
  region  = var.region

  # LocalStack compatibility flags
  skip_credentials_validation = true
  skip_metadata_api_check     = true
}
