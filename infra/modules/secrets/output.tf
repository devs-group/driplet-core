output "session_secret" {
  description = "The ID of the session secret"
  value       = google_secret_manager_secret.session_secret.id
}

output "oauth2_client_secret" {
  description = "The ID of the OAuth2 client secret"
  value       = google_secret_manager_secret.oauth2_client_secret.id
}

output "oauth2_client_id" {
  description = "The ID of the OAuth2 client ID"
  value       = google_secret_manager_secret.oauth2_client_id.id
}
