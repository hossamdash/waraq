locals {
  tf_secrets = {
    mongodb-atlas = {
      data = {
        mongodbatlas_client_id     = var.mongodbatlas_client_id
        mongodbatlas_client_secret = var.mongodbatlas_client_secret
      }
    }
    redis-cloud = {
      data = {
        rediscloud_api_key    = var.rediscloud_api_key
        rediscloud_secret_key = var.rediscloud_secret_key
      }
    }
  }
}

resource "aws_secretsmanager_secret" "terraform_secrets" {
  for_each                = local.tf_secrets
  name                    = "tf-${each.key}"
  recovery_window_in_days = 0

  tags = {
    used_in    = "terraform"
    workspace  = each.key
    managed_by = "terraform"
    env        = "shared"
  }
}

resource "aws_secretsmanager_secret_version" "terraform_secrets_version" {
  for_each      = local.tf_secrets
  secret_id     = aws_secretsmanager_secret.terraform_secrets[each.key].id
  secret_string = jsonencode(each.value.data)
}
