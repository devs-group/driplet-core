terraform {
  backend "gcs" {
    bucket = "driplet-core-sandbox-tf"
    prefix = "driplet/core/sandbox"
  }
}
