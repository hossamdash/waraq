output "arn" {
  description = "ARN of the bucket"
  value       = module.daftar_s3_bucket.s3_bucket_arn
}

output "name" {
  description = "Name (id) of the bucket"
  value       = module.daftar_s3_bucket.s3_bucket_id
}

output "domain" {
  description = "Domain name of the bucket"
  value       = module.daftar_s3_bucket.s3_bucket_website_domain
}

output "website_endpoint" {
  description = "Website endpoint of the bucket"
  value       = module.daftar_s3_bucket.s3_bucket_website_endpoint
}
