provider "aws" {
  version = "~> 1.5"
  region = "us-east-1"
}

terraform {
  backend "local" {
    path = "../terraform.tfstate"
  }
}