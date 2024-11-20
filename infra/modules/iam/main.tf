# Service Account
resource "google_service_account" "driplet_service_account" {
  project      = var.project_id
  account_id   = "driplet-service-account"
  display_name = "Driplet Service Account"
}

# IAM Member for Cloud SQL Client Role
resource "google_project_iam_member" "driplet_service_cloudsql_connector" {
  project = var.project_id
  member  = "serviceAccount:${google_service_account.driplet_service_account.email}"
  role    = "roles/cloudsql.client"
}

# IAM Member for Pub/Sub Admin Role
resource "google_project_iam_member" "driplet_service_pubsub_publisher" {
  project = var.project_id
  member  = "serviceAccount:${google_service_account.driplet_service_account.email}"
  role    = "roles/pubsub.admin"
}

# Grant BigQuery permissions to the Pub/Sub service account
resource "google_project_iam_member" "pubsub_bigquery_access" {
  project = var.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.driplet_service_account.email}"
}

resource "google_project_service_identity" "pubsub" {
  provider = google-beta
  project  = var.project_id
  service  = "pubsub.googleapis.com"
}

resource "google_project_iam_member" "pubsub_bigquery_writer" {
  project = var.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_project_service_identity.pubsub.email}"
}

