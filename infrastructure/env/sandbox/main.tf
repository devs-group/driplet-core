module "driplet_core" {
  source     = "../../module"
  project_id = var.project_id
  region     = var.region

  # BigQuery Variables
  dataset_id          = var.dataset_id
  table_id            = var.table_id
  deletion_protection = var.deletion_protection
  schema              = var.schema
  labels              = var.labels

  # Pub/Sub Variables
  topic_name_client_events = var.topic_name_client_events
  subscription_name        = var.subscription_name

  # Networking Variables
  domain                 = var.domain
  subnetwork_cidr_range  = var.subnetwork_cidr_range
  cloud_run_service_name = var.cloud_run_service_name

  # Compute / Cloud Run Variables
  driplet_image          = var.driplet_image
  database_user          = var.database_user
  oauth_run_callback_url = var.oauth_run_callback_url

  # Environment name (used for resource naming and labels)
  env = var.env
}
