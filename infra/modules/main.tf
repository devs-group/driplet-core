provider "google" {
  project = var.project_id
  region  = var.region
}

# API module
module "api" {
  source     = "./api"
  project_id = var.project_id
}
# Secrets module
module "secrets" {
  source                = "./secrets"
  project_id            = var.project_id
  service_account_email = module.iam.service_account_email
  depends_on            = [module.api]
}

# Compute module
module "compute" {
  source                    = "./compute"
  project_id                = var.project_id
  region                    = var.region
  database_password         = module.database.database_password
  database_connection       = module.database.database_instance_connection_name
  database_user             = module.database.database_user
  cloud_run_service_account = module.iam.service_account_email
  oauth_run_callback_url    = var.oauth_run_callback_url
  oauth_session_secret      = module.secrets.session_secret
  oauth_client_id           = module.secrets.oauth2_client_id
  oauth_client_secret       = module.secrets.oauth2_client_secret
  driplet_image             = var.driplet_image
  depends_on                = [module.api, module.secrets]
}

# Database module
module "database" {
  source     = "./database"
  project_id = var.project_id
  region     = var.region
  depends_on = [module.api]
}

# IAM module
module "iam" {
  source     = "./iam"
  project_id = var.project_id
}

# Network module
module "network" {
  source                 = "./network"
  project_id             = var.project_id
  region                 = var.region
  domain                 = var.domain
  cloud_run_service_name = module.compute.cloud_run_service_name
  depends_on             = [module.api]
}


# Registry module
module "registry" {
  source     = "./registry"
  project_id = var.project_id
  region     = var.region
}

# Pub/Sub module
module "pubsub" {
  source                     = "./pubsub"
  project_id                 = var.project_id
  topic_name_client_events   = var.pubsub_topic_client_events
  publisher_service_account  = module.iam.service_account_email
  subscriber_service_account = module.iam.service_account_email
  subscription_name          = var.pubsub_subscription_client_events
  bigquery_dataset           = var.bigquery_dataset
  bigquery_table             = var.bigquery_table
}

# BigQuery module
module "bigquery" {
  source     = "./bigquery"
  project_id = var.project_id
  dataset_id = var.bigquery_dataset
  table_id   = var.bigquery_table
  schema     = <<EOF
                  [
                    {
                      "name": "data",
                      "type": "STRING",
                      "mode": "NULLABLE",
                      "description": "The data"
                    }
                  ]
                  EOF
  labels = {
    environment = "dev"
    managed_by  = "terraform"
  }
  deletion_protection = false
  depends_on          = [module.iam]
}
