variable "mongodbatlas_client_id" {
  description = "MongoDB Atlas API client ID"
  type        = string
  sensitive   = true
}

variable "mongodbatlas_client_secret" {
  description = "MongoDB Atlas API client secret"
  type        = string
  sensitive   = true
}

variable "mongodbatlas_cluster_region" {
  description = "Region for MongoDB Atlas cluster"
  type        = string
}

variable "mongodbatlas_cloud_provider" {
  description = "Cloud provider for MongoDB Atlas (AWS, GCP, or Azure)"
  type        = string
}
