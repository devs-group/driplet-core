variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "topic_name_client_events" {
  description = "The name of the Pub/Sub topic"
  type        = string
}

variable "subscription_name" {
  description = "The name of the Pub/Sub subscription"
  type        = string
}

variable "publisher_service_account" {
  description = "The service account for publishing messages to the topic"
  type        = string
}

variable "subscriber_service_account" {
  description = "The service account for subscribing to the topic"
  type        = string
}

variable "bigquery_dataset" {
  description = "The BigQuery dataset ID"
  type        = string
}

variable "bigquery_table" {
  description = "The BigQuery table ID"
  type        = string
}
