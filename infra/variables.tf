variable "aws_region" {
  description = "AWS region for most resources (S3, CloudFront metadata)"
  type        = string
  default     = "ap-northeast-1"
}

variable "acm_region" {
  description = "This region for ACM"
  type = string
  default =  "us-east-1"
}

variable "domain_name" {
  description = "My Domain is fuuji.site"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route53 Hosted Zone ID for your domain"
  type        = string
}

variable "bucket_name" {
  description = "Globally unique name for the S3 bucket"
  type        = string
}
