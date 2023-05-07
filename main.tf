terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source = "hashicorp/random"
    }
  }

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
