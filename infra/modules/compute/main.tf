# Enable Cloud Run API
resource "google_project_service" "cloud_run" {
  project = var.project_id
  service = "run.googleapis.com"
}

# Cloud Run Service
resource "google_cloud_run_v2_service" "driplet_service" {
  name                = "driplet-service"
  location            = var.region
  ingress             = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
  deletion_protection = false

  template {
    containers {
      image = var.driplet_image
      ports {
        container_port = 1991
      }

      volume_mounts {
        name       = "cloudsql"
        mount_path = "/cloudsql"
      }

      env {
        name  = "POSTGRES_CONNECTION_STRING"
        value = "postgresql://${var.database_user}:${var.database_password}@/postgres?host=/cloudsql/${var.database_connection}"
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
        value = var.oauth_run_callback_url
      }

      env {
        name  = "PUBSUB_PROJECT_ID"
        value = var.project_id
      }

      env {
        name = "SESSION_SECRET"
        value_source {
          secret_key_ref {
            secret  = var.oauth_session_secret
            version = "latest"
          }
        }
      }

      env {
        name = "GOOGLE_CLIENT_ID"
        value_source {
          secret_key_ref {
            secret  = var.oauth_client_id
            version = "latest"
          }
        }
      }
      env {
        name = "GOOGLE_CLIENT_SECRET"
        value_source {
          secret_key_ref {
            secret  = var.oauth_client_secret
            version = "latest"
          }
        }
      }
    }

    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [var.database_connection]
      }
    }

    service_account = var.cloud_run_service_account
  }
}

# IAM Member for Cloud Run Service Invoker
resource "google_cloud_run_service_iam_member" "service_invoker" {
  service  = google_cloud_run_v2_service.driplet_service.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}
