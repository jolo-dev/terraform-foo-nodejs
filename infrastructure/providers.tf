# I need a load balancer, EC2 in autoscaling group in a vpc with high availability and an RDS database in a private subnet all in Terraform

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }
  required_version = ">= 1.2"
}

provider "aws" {
  shared_credentials_files = ["$HOME/.aws/credentials"]
  region                   = var.region
}
