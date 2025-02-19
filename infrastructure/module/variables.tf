variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

# BigQuery Variables
variable "dataset_id" {
  description = "BigQuery dataset ID"
  type        = string
}

variable "table_id" {
  description = "BigQuery table ID"
  type        = string
}

variable "deletion_protection" {
  description = "Enable deletion protection for the BigQuery table"
  type        = bool
  default     = false
}

variable "schema" {
  description = "The JSON schema for the BigQuery table"
  type        = string
}

variable "labels" {
  description = "Optional labels for the BigQuery dataset"
  type        = map(string)
  default     = {}
}

# Pub/Sub Variables
variable "topic_name_client_events" {
  description = "Name of the Pub/Sub topic for client events"
  type        = string
}

variable "subscription_name" {
  description = "Name of the Pub/Sub subscription"
  type        = string
}

# Networking Variables
variable "domain" {
  description = "The domain name for the SSL certificate"
  type        = string
}

variable "subnetwork_cidr_range" {
  description = "The CIDR range for the subnetwork"
  type        = string
}

variable "cloud_run_service_name" {
  description = "The Cloud Run service name for the network endpoint group"
  type        = string
}

# Compute / Cloud Run Variables
variable "driplet_image" {
  description = "Container image for the Cloud Run service"
  type        = string
}

variable "driplet_scheduler_image" {
  description = "Container image for the Cloud Run service"
  type        = string
}

variable "database_user" {
  description = "Database username for connecting to Cloud SQL"
  type        = string
}

variable "oauth_run_callback_url" {
  description = "OAuth callback URL for Cloud Run"
  type        = string
}

# New variable for environment name (used for resource naming and labels)
variable "env" {
  description = "Environment name (e.g., 'sandbox', 'dev', 'prod')"
  type        = string
  default     = ""
}
