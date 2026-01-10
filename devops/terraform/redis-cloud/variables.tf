variable "rediscloud_api_key" {
  description = "Redis Cloud API key"
  type        = string
  sensitive   = true
}

variable "rediscloud_secret_key" {
  description = "Redis Cloud secret key"
  type        = string
  sensitive   = true
}

variable "redis_cloud_region" {
  description = "Cloud provider region for Redis Cloud"
  type        = string
}

variable "redis_cloud_provider" {
  description = "Cloud provider for Redis Cloud (AWS, GCP, or Azure)"
  type        = string
}
