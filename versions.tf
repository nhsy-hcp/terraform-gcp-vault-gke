terraform {
  required_version = ">=1.2.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.84.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.84.0"
    }
    local = {
      source = "hashicorp/local"
      #      version = "~> 2.0"
    }
    random = {
      source = "hashicorp/random"
      #version = "~> 3.0"
    }
  }
}