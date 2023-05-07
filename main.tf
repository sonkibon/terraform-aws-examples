terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = " 3.74.2"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.1"
    }
  }

  required_version = ">= 0.13"

  cloud {
    organization = "son-org"

    workspaces {
      name = "son-workspace"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
