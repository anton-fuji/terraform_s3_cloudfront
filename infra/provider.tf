# Default
provider "aws" {
  region = var.aws_region
}

# ACM
provider "aws" {
  alias  = "use1"
  region = var.acm_region
}