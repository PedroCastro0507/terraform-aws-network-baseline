terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

module "network" {
  source = "../.."

  name               = "demo"
  azs                = ["ap-southeast-2a", "ap-southeast-2b"]
  enable_nat_gateway = true

  tags = {
    Environment = "example"
  }
}

output "vpc_id" {
  value = module.network.vpc_id
}
