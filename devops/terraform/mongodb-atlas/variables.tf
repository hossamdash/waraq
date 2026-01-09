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

variable "mongdbatlas_email" {
  description = "MongoDB Atlas account email address"
  type        = string
}

variable "mongodbatlas_cluster_region_aws" {
  description = "AWS region for MongoDB Atlas cluster"
  type        = string
}


# variable "mongodb_db_password" {
#   description = "MongoDB database user password"
#   type        = string
#   sensitive   = true
# }

# variable "mongodb_db_username" {
#   description = "MongoDB database username"
#   type        = string
#   sensitive   = true
# }
