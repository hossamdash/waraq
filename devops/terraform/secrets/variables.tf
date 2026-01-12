variable "region" {
  type        = string
  description = "The aws cloud region to deploy to"
}

# MongoDB Atlas credentials
variable "mongodbatlas_client_id" {
  type        = string
  description = "MongoDB Atlas Client ID"
  sensitive   = true
}

variable "mongodbatlas_client_secret" {
  type        = string
  description = "MongoDB Atlas Client Secret"
  sensitive   = true
}

# Redis Cloud credentials
variable "rediscloud_api_key" {
  type        = string
  description = "Redis Cloud API Key"
  sensitive   = true
}

variable "rediscloud_secret_key" {
  type        = string
  description = "Redis Cloud Secret Key"
  sensitive   = true
}
