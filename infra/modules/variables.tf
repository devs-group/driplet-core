# Project configuration
variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
  default     = "us-central1"
}

# Network configuration
variable "network_name" {
  description = "The name of the VPC network"
  type        = string
  default     = "default-network"
}

variable "subnet_ranges" {
  description = "A map of subnet names to CIDR ranges"
  type        = map(string)
  default = {
    "subnet-1" = "10.0.1.0/24"
    "subnet-2" = "10.0.2.0/24"
  }
}

# Database configuration
variable "database_instance_name" {
  description = "The name of the Cloud SQL database instance"
  type        = string
  default     = "driplet-application-db"
}

variable "database_user" {
  description = "The username for the database"
  type        = string
  default     = "driplet_application_user"
}

# Cloud Run configuration
variable "cloud_run_service_name" {
  description = "The name of the Cloud Run service"
  type        = string
  default     = "driplet-service"
}

variable "driplet_image" {
  description = "The Docker image URL for the Cloud Run service"
  type        = string
}

variable "oauth_run_callback_url" {
  description = "The callback URL for Google OAuth in the Cloud Run service"
  type        = string
}

# Pub/Sub configuration
variable "pubsub_topic_client_events" {
  description = "The Pub/Sub topic for client events"
  type        = string
}

# Artifact Registry configuration
variable "artifact_registry_repository_id" {
  description = "The ID of the Artifact Registry repository"
  type        = string
}

# IAM configuration
variable "service_account_email" {
  description = "The email of the service account used by Cloud Run and other services"
  type        = string
}

# API configuration
variable "enable_apis" {
  description = "Enable necessary Google Cloud APIs for the project"
  type        = bool
  default     = true
}

# Other configuration
variable "domain" {
  description = "The domain for the SSL certificate"
  type        = string
  default     = "driplet.codify.ch"
}

# BigQuery configuration
variable "bigquery_dataset" {
  description = "The ID of the BigQuery dataset"
  type        = string
}

variable "bigquery_table" {
  description = "The ID of the BigQuery table"
  type        = string
}

variable "pubsub_subscription_client_events" {
  description = "The name of the Pub/Sub subscription"
  type        = string
}
