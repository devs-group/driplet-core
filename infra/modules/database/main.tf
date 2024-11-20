# SQL Database Instance
resource "google_sql_database_instance" "driplet_application_db" {
  database_version = "POSTGRES_17"
  region           = var.region
  name             = "driplet-application-db"

  settings {
    tier = "db-perf-optimized-N-2"
    database_flags {
      name  = "cloudsql.iam_authentication"
      value = "on"
    }
  }
}

# Random password for the SQL user
resource "random_password" "driplet_application_db_password" {
  length    = 64
  special   = false
  min_upper = 5
  min_lower = 5
}

# SQL User
resource "google_sql_user" "driplet_application_db_user" {
  name     = "driplet_application_user"
  password = random_password.driplet_application_db_password.result
  instance = google_sql_database_instance.driplet_application_db.name
}
