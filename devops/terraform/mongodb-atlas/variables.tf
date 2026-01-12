variable "region" {
  description = "AWS region for Secrets Manager"
  type        = string
}

variable "mongodbatlas_cluster_region" {
  description = "Region for MongoDB Atlas cluster"
  type        = string
}

variable "mongodbatlas_cloud_provider" {
  description = "Cloud provider for MongoDB Atlas (AWS, GCP, or Azure)"
  type        = string
}
