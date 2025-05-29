#  Get the thumbprint by OIDC provider
data "http" "github_actions_openid_configuration" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

data "tls_certificate" "github_actions" {
  url = jsondecode(data.http.github_actions_openid_configuration.response_body).jwks_uri
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = data.tls_certificate.github_actions.certificates[*].sha1_fingerprint
}


# IAM Role Assume Policy 
data "aws_iam_policy_document" "github_actions_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_actions.arn]
    }
    condition {
      test       = "StringEquals"
      variable   = "token.actions.githubusercontent.com:aud"
      values     = ["sts.amazonaws.com"]
    }

    # Allow authentication only from the main branch
    condition {
      test       = "StringEquals"
      variable   = "token.actions.githubusercontent.com:sub"
      values     = ["repo:anton-fuji/portfolio:ref:refs/heads/main"]
    }
  }
}


# IAM roles assumed by GitHub Actions
resource "aws_iam_role" "github_actions_deployer_role" {
  name             = "github-actions-deployment-role" 
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role_policy.json
}


# Custom policies for S3 deployment and CloudFront cache invalidation
resource "aws_iam_policy" "s3_cloudfront_deploy_policy" { 
  name        = "s3-cloudfront-deploy-access-for-github-actions"
  description = "Allows GitHub Actions to deploy static website to S3 bucket and invalidate CloudFront cache."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",      
          "s3:DeleteObject",   
          "s3:ListBucket",     
          "s3:GetObject"      
        ]
        Resource = [
          aws_s3_bucket.site_bucket.arn,
          "${aws_s3_bucket.site_bucket.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "cloudfront:CreateInvalidation", 
          "cloudfront:GetDistribution"     
        ]
        Resource = aws_cloudfront_distribution.cdn.arn
      }
    ]
  })
}


# Attach a custom policy to an IAM role
resource "aws_iam_role_policy_attachment" "s3_cloudfront_deploy_attachment" { 
  role       = aws_iam_role.github_actions_deployer_role.name 
  policy_arn = aws_iam_policy.s3_cloudfront_deploy_policy.arn 
}
