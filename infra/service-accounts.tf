resource "google_service_account" "driplet_service_account" {
  project      = var.project_id
  account_id   = "driplet-service-account"
  display_name = "Driplet Service Account"
}

resource "google_project_iam_member" "driplet_service_cloudsql_connector" {
  project = var.project_id
  member  = "serviceAccount:${google_service_account.driplet_service_account.email}"
  role    = "roles/cloudsql.client"
}

// add pubsub publisher role to driplet service account
resource "google_project_iam_member" "driplet_service_pubsub_publisher" {
  project = var.project_id
  member  = "serviceAccount:${google_service_account.driplet_service_account.email}"
  role    = "roles/pubsub.publisher"
}

// add pubsub subscriber role to driplet service account
resource "google_project_iam_member" "driplet_service_pubsub_reader" {
  project = var.project_id
  member  = "serviceAccount:${google_service_account.driplet_service_account.email}"
  role    = "roles/pubsub.subscriber"
}
