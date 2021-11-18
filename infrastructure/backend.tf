terraform {
  backend "remote" {
    organization = "mohamed_ali_test_org1"

    workspaces {
      name = "task"
    }
  }

  required_version = ">= 0.13.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
