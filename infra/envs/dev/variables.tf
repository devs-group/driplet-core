# Variable declarations for the dev environment
variable "project_id" {
  description = "The GCP project ID for the dev environment"
  type        = string
}

variable "region" {
  description = "The GCP region for resources in the dev environment"
  type        = string
}

variable "domain" {
  description = "The domain for SSL certificates and other configurations in the dev environment"
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network in the dev environment"
  type        = string
}

variable "subnet_ranges" {
  description = "A map of subnet names to CIDR ranges in the dev environment"
  type        = map(string)
}

variable "database_instance_name" {
  description = "The name of the Cloud SQL database instance in the dev environment"
  type        = string
}

variable "database_user" {
  description = "The username for the database in the dev environment"
  type        = string
}

variable "cloud_run_service_name" {
  description = "The name of the Cloud Run service in the dev environment"
  type        = string
}

variable "image_name" {
  description = "The name of the Docker image in the dev environment"
  type        = string
}

variable "image_tag" {
  description = "The tag of the Docker image in the dev environment"
  type        = string
}

variable "oauth_run_callback_url" {
  description = "The callback URL for Google OAuth in the Cloud Run service in the dev environment"
  type        = string
}

variable "pubsub_topic_client_events" {
  description = "The Pub/Sub topic for client events in the dev environment"
  type        = string
}

variable "artifact_registry_repository_id" {
  description = "The ID of the Artifact Registry repository in the dev environment"
  type        = string
}

variable "bigquery_dataset" {
  description = "The ID of the BigQuery dataset in the dev environment"
  type        = string
}

variable "bigquery_table" {
  description = "The ID of the BigQuery table in the dev environment"
  type        = string
}

variable "pubsub_subscription_client_events" {
  description = "The name of the Pub/Sub subscription in the dev environment"
  type        = string
}