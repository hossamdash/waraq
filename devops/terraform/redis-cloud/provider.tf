terraform {
  required_providers {
    rediscloud = {
      source  = "RedisLabs/rediscloud"
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


data "aws_secretsmanager_secret" "redis_cloud_credentials" {
  name = "tf-redis-cloud"
}

data "aws_secretsmanager_secret_version" "redis_cloud_credentials" {
  secret_id = data.aws_secretsmanager_secret.redis_cloud_credentials.id
}

locals {
  redis_credentials = jsondecode(data.aws_secretsmanager_secret_version.redis_cloud_credentials.secret_string)
}

provider "rediscloud" {
  api_key    = local.redis_credentials.rediscloud_api_key
  secret_key = local.redis_credentials.rediscloud_secret_key
}
