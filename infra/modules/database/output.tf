output "database_instance_name" {
  description = "The name of the database instance"
  value       = google_sql_database_instance.driplet_application_db.name
}

output "database_instance_connection_name" {
  description = "The connection name for the database instance"
  value       = google_sql_database_instance.driplet_application_db.connection_name
}

output "database_user" {
  description = "The name of the database user"
  value       = google_sql_user.driplet_application_db_user.name
}

output "database_password" {
  description = "The password for the database user (sensitive)"
  value       = random_password.driplet_application_db_password.result
  sensitive   = true
}
