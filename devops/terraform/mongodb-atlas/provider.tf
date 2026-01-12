terraform {
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "~> 2.0"
    }
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


data "aws_secretsmanager_secret" "mongodb_atlas_credentials" {
  name = "tf-mongodb-atlas"
}

data "aws_secretsmanager_secret_version" "mongodb_atlas_credentials" {
  secret_id = data.aws_secretsmanager_secret.mongodb_atlas_credentials.id
}

locals {
  mongodb_credentials = jsondecode(data.aws_secretsmanager_secret_version.mongodb_atlas_credentials.secret_string)
}

provider "mongodbatlas" {
  client_id     = local.mongodb_credentials.mongodbatlas_client_id
  client_secret = local.mongodb_credentials.mongodbatlas_client_secret
}
