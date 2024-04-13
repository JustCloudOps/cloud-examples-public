terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
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
      repo      = "github.com/j-worr/cloud-examples-public"
      env       = "dev"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks-cluster-1.cluster.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks-cluster-1.cluster.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks-cluster-1.cluster.cluster_name]
      command     = "aws"
    }
  }
  alias = "eks-cluster-1"
}
