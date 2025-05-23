# Create S3 bucket
resource "aws_s3_bucket" "site_bucket" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
    Environment = "Production"
  }
}

# Ownership controls
resource "aws_s3_bucket_ownership_controls" "site_bucket" {
  bucket = aws_s3_bucket.site_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Configure S3 bucket ACL
resource "aws_s3_bucket_acl" "site_bucket" {
  depends_on = [ 
    aws_s3_bucket_ownership_controls.site_bucket,
    aws_s3_bucket_public_access_block.site_bucket,
   ]

   bucket = aws_s3_bucket.site_bucket.id
   acl = "private"
}

# Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for ${var.bucket_name}"
}

# Public Access Block
resource "aws_s3_bucket_public_access_block" "site_bucket" {
  bucket = aws_s3_bucket.site_bucket.id

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

# bucket policy to allow CloudFront access
resource "aws_s3_bucket_policy" "site_bucket_policy" {
  bucket = aws_s3_bucket.site_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "AllowCloudFrontAccess" 
      Effect    = "Allow"
      Principal = { 
        AWS = aws_cloudfront_origin_access_identity.oai.iam_arn 
      }
      Action    = [
        "s3:GetObject"
      ]
      Resource  = [
        "${aws_s3_bucket.site_bucket.arn}/*"
      ]
    }]
  })
}
