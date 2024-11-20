output "cloud_run_api" {
  description = "Cloud Run API status"
  value       = google_project_service.cloud_run.service
}

output "artifact_registry_api" {
  description = "Artifact Registry API status"
  value       = google_project_service.artifact_registry.service
}

output "cloud_sql_api" {
  description = "Cloud SQL API status"
  value       = google_project_service.cloud_sql.service
}

output "secret_manager_api" {
  description = "Secret Manager API status"
  value       = google_project_service.secret_manager.service
}

output "pubsub_api" {
  description = "Pub/Sub API status"
  value       = google_project_service.pubsub.service
}

output "iam_api" {
  description = "IAM API status"
  value       = google_project_service.iam.service
}

output "service_networking_api" {
  description = "Service Networking API status"
  value       = google_project_service.service_networking.service
}

output "compute_api" {
  description = "Compute Engine API status"
  value       = google_project_service.compute.service
}
