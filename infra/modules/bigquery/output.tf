output "dataset_id" {
  description = "The ID of the BigQuery dataset"
  value       = google_bigquery_dataset.dataset.dataset_id
}

output "table_id" {
  description = "The ID of the BigQuery table"
  value       = google_bigquery_table.table.table_id
}

output "dataset_project" {
  description = "The GCP project where the dataset is created"
  value       = google_bigquery_dataset.dataset.project
}
