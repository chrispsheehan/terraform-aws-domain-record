terraform {
  required_version = ">= 1.0.8"
  required_providers {
    aws = {
      version               = ">= 4.15.0"
      source                = "hashicorp/aws"
      configuration_aliases = [aws.us-east-1]
    }
  }
}
