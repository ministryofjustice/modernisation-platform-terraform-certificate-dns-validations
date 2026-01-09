terraform {
  required_providers {
    aws = {
      version               = "~> 6.0"
      source                = "hashicorp/aws"
      configuration_aliases = [aws.core-vpc, aws.core-network-services]
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.3"
    }
  }
  required_version = "~> 1.0"
}
