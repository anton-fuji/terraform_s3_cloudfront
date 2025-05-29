data "aws_caller_identity" "me" {}

output "account_id" {
  value = data.aws_caller_identity.me.account_id
}

# S3
output "bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.site_bucket.bucket
}

# CloudFront
output "cloudfront_domain_name" {
  description = "CloudFront domain name"
  value       = aws_cloudfront_distribution.cdn.domain_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.cdn.id
}

# ACM
output "certificate_arn" {
  description = "ACM certificate ARN"
  value       = aws_acm_certificate.cert.arn
}

# the ARN of the GitHub Actions role
output "github_actions_deployer_role_arn" {
  description = "ARN of the IAM Role for GitHub Actions deployment"
  value       = aws_iam_role.github_actions_deployer_role.arn
}
