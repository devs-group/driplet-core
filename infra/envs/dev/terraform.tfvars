# Environment-specific variables for dev

# General configuration
project_id = "driplet-core-dev"
region     = "europe-west1"

# Networking configuration
network_name  = "driplet-vpc"
subnet_ranges = { "driplet-subnet" = "10.0.1.0/24" }

# Database configuration
database_instance_name = "driplet-application-db"
database_user          = "driplet_app_user"

# Artifact Registry configuration
artifact_registry_repository_id = "driplet-repository"

# Cloud Run configuration
cloud_run_service_name = "driplet-service"
oauth_run_callback_url = "https://dev.driplet.codify.ch/auth/google/callback"

# Docker image configuration
image_name = "driplet"
image_tag  = "latest"

# Pub/Sub configuration
pubsub_topic_client_events        = "client-events"
pubsub_subscription_client_events = "client-events-bigquery"

# BigQuery configuration


# Load balancer configuration
domain = "dev.driplet.codify.ch"

# BigQuery configuration
bigquery_table   = "client_events"
bigquery_dataset = "source"
