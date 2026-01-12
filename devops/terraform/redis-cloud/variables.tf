variable "region" {
  description = "AWS region for Secrets Manager"
  type        = string
}

variable "redis_cloud_region" {
  description = "Cloud provider region for Redis Cloud"
  type        = string
}

variable "redis_cloud_provider" {
  description = "Cloud provider for Redis Cloud (AWS, GCP, or Azure)"
  type        = string
}
