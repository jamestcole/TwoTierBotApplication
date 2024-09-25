# Configure the AWS provider
provider "aws" {
  region = var.aws_region
}

# Optionally configure provider profile if you're using multiple profiles
# provider "aws" {
#   region  = var.aws_region
#   profile = "your-aws-profile"
# }
