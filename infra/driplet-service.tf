resource "google_project_service" "cloud_run" {
  project = var.project_id
  service = "run.googleapis.com"
}

resource "google_cloud_run_v2_service" "driplet_service" {
  name                = "driplet-service"
  location            = var.region
  ingress             = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
  deletion_protection = false


  template {
    containers {
      ports {
        container_port = 1991
      }
      image = "europe-west1-docker.pkg.dev/driplet-core-prod/driplet-repository/driplet:latest"
      volume_mounts {
        name       = "cloudsql"
        mount_path = "/cloudsql"
      }

      env {
        name  = "DATABASE_URL"
        value = "postgresql://driplet_application_user:${random_password.driplet_application_db_password.result}@/postgres?host=/cloudsql/${google_sql_database_instance.driplet_application_db.connection_name}"
      }

      env {
        name  = "GOOGLE_PUBSUB_TOPIC_CLIENT_EVENTS"
        value = "client-events"
      }

      env {
        name  = "GOOGLE_PROJECT_ID"
        value = var.project_id
      }

      env {
        name  = "GOOGLE_CALLBACK_URL"
        value = "https://driplet.codify.ch/auth/google/callback"
      }

      #env {
      #  name  = "PUBSUB_EMULATOR_HOST"
      #  value = "pubsub:8085"
      #}

      env {
        name  = "PUBSUB_PROJECT_ID"
        value = var.project_id
      }

      env {
        name = "SESSION_SECRET"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.session-secret.secret_id
            version = "latest"
          }
        }
      }

      env {
        name = "GOOGLE_CLIENT_ID"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.oauth2-client-id.secret_id
            version = "latest"
          }
        }
      }
      env {
        name = "GOOGLE_CLIENT_SECRET"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.oauth2-client-secret.secret_id
            version = "latest"
          }
        }
      }
    }

    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [google_sql_database_instance.driplet_application_db.connection_name]
      }
    }

    service_account = google_service_account.driplet_service_account.email
  }
}

resource "google_cloud_run_service_iam_member" "service_invoker" {
  service  = google_cloud_run_v2_service.driplet_service.name
  location = google_cloud_run_v2_service.driplet_service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}