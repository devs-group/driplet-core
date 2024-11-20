variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
}

variable "cloud_run_service_account" {
  description = "Email of the service account for Cloud Run"
  type        = string
}

variable "oauth_run_callback_url" {
  description = "The callback URL for Google OAuth in the Cloud Run service"
  type        = string
}

variable "database_user" {
  description = "The user for the database"
  type        = string
}

variable "database_password" {
  description = "The password for the database user (sensitive)"
  type        = string
  sensitive   = true
}

variable "database_connection" {
  description = "The connection name of the Cloud SQL instance"
  type        = string
}

variable "oauth_session_secret" {
  description = "The ID of the session secret"
  type        = string
}

variable "oauth_client_id" {
  description = "The ID of the OAuth2 client ID"
  type        = string
}

variable "oauth_client_secret" {
  description = "The ID of the OAuth2 client secret"
  type        = string
}

variable "driplet_image" {
  description = "The Docker image URL for the Cloud Run service"
  type        = string
}
