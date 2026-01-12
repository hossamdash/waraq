module "daftar_s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.0"

  bucket = var.bucket_name
  tags   = var.tags

  # Public access configuration
  # !NOTE cloudfront is not supported in localstack
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  # Website configuration
  website = {
    index_document = "index.html"
    error_document = "404.html"
  }

  # Bucket policy for public read access
  attach_policy = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${var.bucket_name}/*"
      },
    ]
  })
}

# test upload some assets to the bucket, without including assets/ root folder

module "template_files" {
  source  = "hashicorp/dir/template"
  version = "~> 1.0"

  base_dir = "${path.module}/assets"
}

resource "aws_s3_object" "object_assets" {
  depends_on   = [module.daftar_s3_bucket, module.template_files]
  for_each     = module.template_files.files
  bucket       = var.bucket_name
  key          = each.key
  content_type = each.value.content_type
  source       = each.value.source_path
  etag         = each.value.digests.md5
}
