# BigQuery Dataset
resource "google_bigquery_dataset" "dataset" {
  dataset_id = var.dataset_id
  project    = var.project_id

  location = "EU"

  # Optional labels
  labels = var.labels
}

# BigQuery Table
resource "google_bigquery_table" "table" {
  table_id            = var.table_id
  dataset_id          = google_bigquery_dataset.dataset.dataset_id
  project             = var.project_id
  deletion_protection = var.deletion_protection

  # Table schema (as JSON string)
  schema = var.schema
}
