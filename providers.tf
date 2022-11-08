# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.38.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.accesskey
  secret_key = var.secretkey
}

provider "aws" {
  access_key = "enterhere"
  secret_key = "enterhere"
  alias      = "acm_provider"
  region     = "us-east-1"
}
