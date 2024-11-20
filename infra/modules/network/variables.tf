variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
}

variable "domain" {
  description = "The domain for the SSL certificate"
  type        = string
  default     = "example.com"
}

variable "cloud_run_service_name" {
  description = "The name of the Cloud Run service for the NEG"
  type        = string
}