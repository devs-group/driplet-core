# Cloud Run API
resource "google_project_service" "cloud_run" {
  project = var.project_id
  service = "run.googleapis.com"
}

# Artifact Registry API
resource "google_project_service" "artifact_registry" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"
}

# Cloud SQL Admin API
resource "google_project_service" "cloud_sql" {
  project = var.project_id
  service = "sqladmin.googleapis.com"
}

# Secret Manager API
resource "google_project_service" "secret_manager" {
  project = var.project_id
  service = "secretmanager.googleapis.com"
}

# Pub/Sub API
resource "google_project_service" "pubsub" {
  project = var.project_id
  service = "pubsub.googleapis.com"
}

# BigQuery API
resource "google_project_service" "bigquery" {
  project = var.project_id
  service = "bigquery.googleapis.com"
}

# IAM API
resource "google_project_service" "iam" {
  project = var.project_id
  service = "iam.googleapis.com"
}

# Service Networking API
resource "google_project_service" "service_networking" {
  project = var.project_id
  service = "servicenetworking.googleapis.com"
}

# Compute Engine API
resource "google_project_service" "compute" {
  project = var.project_id
  service = "compute.googleapis.com"
}