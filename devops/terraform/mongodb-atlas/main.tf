locals {
  common_resource_prefix = "waraq"
}

data "mongodbatlas_roles_org_id" "current" {}

resource "mongodbatlas_project" "waraq" {
  name   = local.common_resource_prefix
  org_id = data.mongodbatlas_roles_org_id.current.org_id
}


resource "mongodbatlas_advanced_cluster" "free_tier_cluster" {
  project_id   = mongodbatlas_project.waraq.id
  name         = "${local.common_resource_prefix}-cluster-001"
  cluster_type = "REPLICASET"

  replication_specs = [
    {
      region_configs = [
        {
          electable_specs = {
            instance_size = "M0"
          }
          provider_name         = "TENANT"
          backing_provider_name = var.mongodbatlas_cloud_provider
          region_name           = var.mongodbatlas_cluster_region
          priority              = 7
        }
      ]
    }
  ]
}
