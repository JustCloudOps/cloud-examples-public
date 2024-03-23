terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.15"
    }
  }
  required_version = ">=1.3.5"
}

provider "aws" {
  #allowed_account_ids = [ "123456789123", ] safeguard to env and account are aligned
  default_tags {
    tags = {
      terraform = "true"
      repo = "github.com/j-worr/examples-public"
      env = "dev"
    }
  }
}