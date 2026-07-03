terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote backend for shared state + state locking.
  # Bucket and DynamoDB table must be created once, manually or via a
  # bootstrap script, before running `terraform init` here.

# backend "s3" {
#   bucket         = "devops-assessment-tfstate-REPLACE_ME"
#   key            = "eks/terraform.tfstate"
#   region         = "us-east-1"
#   dynamodb_table = "devops-assessment-tf-locks"
#   encrypt        = true
# }

provider "aws" {
  region = var.aws_region
}
