terraform {
  required_providers {
    google-beta = {
      source = "hashicorp/google-beta"
    }
    google = {
      source  = "hashicorp/google"
      version = "6.9.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}
