locals {
  common_resource_prefix = "waraq"
}

data "rediscloud_essentials_plan" "free_tier" {
  # corresponds to Free Tier plan
  size                  = 30
  size_measurement_unit = "MB"
  cloud_provider        = var.redis_cloud_provider
  region                = var.redis_cloud_region
}

resource "rediscloud_essentials_subscription" "waraq" {
  name    = "${local.common_resource_prefix}-redis-001"
  plan_id = data.rediscloud_essentials_plan.free_tier.id
}

resource "rediscloud_essentials_database" "db" {
  subscription_id     = rediscloud_essentials_subscription.waraq.id
  name                = "${local.common_resource_prefix}-redis-001"
  enable_default_user = true
  redis_version       = 7.4
  protocol            = "stack"
  # changed to never run out of memory
  data_eviction    = "allkeys-lru"
  data_persistence = "none"
  replication      = false

  alert {
    name  = "connections-limit"
    value = 80
  }
  alert {
    name  = "datasets-size"
    value = 80
  }
}
