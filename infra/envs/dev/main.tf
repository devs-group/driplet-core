# Provider configuration
provider "google" {
  project = var.project_id
  region  = var.region
}
locals {
  driplet_image         = "europe-west1-docker.pkg.dev/${var.project_id}/${var.artifact_registry_repository_id}/${var.image_name}:${var.image_tag}"
  service_account_email = "driplet-service-account@${var.project_id}.iam.gserviceaccount.com"
}

module "main" {
  source = "../../modules"

  project_id                        = var.project_id
  region                            = var.region
  domain                            = var.domain
  network_name                      = var.network_name
  subnet_ranges                     = var.subnet_ranges
  database_instance_name            = var.database_instance_name
  database_user                     = var.database_user
  cloud_run_service_name            = var.cloud_run_service_name
  driplet_image                     = local.driplet_image
  oauth_run_callback_url            = var.oauth_run_callback_url
  pubsub_topic_client_events        = var.pubsub_topic_client_events
  artifact_registry_repository_id   = var.artifact_registry_repository_id
  service_account_email             = local.service_account_email
  bigquery_dataset                  = var.bigquery_dataset
  bigquery_table                    = var.bigquery_table
  pubsub_subscription_client_events = var.pubsub_subscription_client_events
}
