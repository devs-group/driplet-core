# -----------------------------------------------------------
# Enable Required Google Cloud APIs
# -----------------------------------------------------------

resource "google_project_service" "cloud_run" {
  project            = var.project_id
  service            = "run.googleapis.com"
  disable_on_destroy = false

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project_service" "artifact_registry" {
  project            = var.project_id
  service            = "artifactregistry.googleapis.com"
  disable_on_destroy = false

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project_service" "cloud_sql" {
  project            = var.project_id
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = false

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project_service" "secret_manager" {
  project            = var.project_id
  service            = "secretmanager.googleapis.com"
  disable_on_destroy = false

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project_service" "pubsub" {
  project            = var.project_id
  service            = "pubsub.googleapis.com"
  disable_on_destroy = false

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project_service" "bigquery" {
  project            = var.project_id
  service            = "bigquery.googleapis.com"
  disable_on_destroy = false

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project_service" "iam" {
  project            = var.project_id
  service            = "iam.googleapis.com"
  disable_on_destroy = false

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project_service" "service_networking" {
  project            = var.project_id
  service            = "servicenetworking.googleapis.com"
  disable_on_destroy = false

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project_service" "compute" {
  project            = var.project_id
  service            = "compute.googleapis.com"
  disable_on_destroy = false

  lifecycle {
    prevent_destroy = true
  }
}

# -----------------------------------------------------------
# IAM Resources
# -----------------------------------------------------------

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

resource "google_project_iam_member" "driplet_service_pubsub_publisher" {
  project = var.project_id
  member  = "serviceAccount:${google_service_account.driplet_service_account.email}"
  role    = "roles/pubsub.admin"
}

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

# -----------------------------------------------------------
# Secret Manager Resources
# -----------------------------------------------------------

resource "google_secret_manager_secret" "session_secret" {
  labels    = { component = "driplet", managed = "terraform" }
  project   = var.project_id
  secret_id = "session-secret"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_iam_member" "session_auth_secret" {
  secret_id  = google_secret_manager_secret.session_secret.id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${google_service_account.driplet_service_account.email}"
  depends_on = [google_secret_manager_secret.session_secret]
}

resource "google_secret_manager_secret" "oauth2_client_secret" {
  labels    = { component = "driplet", managed = "terraform" }
  project   = var.project_id
  secret_id = "oauth2-client-secret"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_iam_member" "oauth2_client_secret_member" {
  secret_id  = google_secret_manager_secret.oauth2_client_secret.id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${google_service_account.driplet_service_account.email}"
  depends_on = [google_secret_manager_secret.oauth2_client_secret]
}

resource "google_secret_manager_secret" "oauth2_client_id" {
  labels    = { component = "driplet", managed = "terraform" }
  project   = var.project_id
  secret_id = "oauth2-client-id"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_iam_member" "oauth2_client_id_member" {
  secret_id  = google_secret_manager_secret.oauth2_client_id.id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${google_service_account.driplet_service_account.email}"
  depends_on = [google_secret_manager_secret.oauth2_client_id]
}

# -----------------------------------------------------------
# Artifact Registry Repository (using google-beta for cleanup_policies)
# -----------------------------------------------------------

resource "google_artifact_registry_repository" "driplet_registry" {
  provider      = google-beta
  project       = var.project_id
  location      = var.region
  repository_id = "driplet-repository"
  description   = "Driplet Repository"
  format        = "DOCKER"

  cleanup_policies {
    id     = "delete_old_images"
    action = "DELETE"
    condition {
      older_than = "432000s" # 5 days
    }
  }

  cleanup_policies {
    id     = "keep_last_2_versions"
    action = "KEEP"
    most_recent_versions {
      keep_count = 2
    }
  }
}

# -----------------------------------------------------------
# BigQuery Resources
# -----------------------------------------------------------

resource "google_bigquery_dataset" "dataset" {
  dataset_id = var.dataset_id
  project    = var.project_id
  location   = "EU"
  labels     = var.labels
}

resource "google_bigquery_table" "table" {
  table_id            = var.table_id
  dataset_id          = google_bigquery_dataset.dataset.dataset_id
  project             = var.project_id
  deletion_protection = var.deletion_protection
  schema              = var.schema
}

# -----------------------------------------------------------
# Pub/Sub Resources
# -----------------------------------------------------------

resource "google_pubsub_topic" "client_events" {
  name                       = var.topic_name_client_events
  project                    = var.project_id
  message_retention_duration = "604800s" # 7 days
}

resource "google_pubsub_subscription" "bigquery_subscription" {
  name                       = var.subscription_name
  topic                      = google_pubsub_topic.client_events.id
  project                    = var.project_id
  ack_deadline_seconds       = 600       # 10 minutes
  message_retention_duration = "604800s" # 7 days

  bigquery_config {
    table               = "${var.project_id}.${google_bigquery_dataset.dataset.dataset_id}.${var.table_id}"
    write_metadata      = false
    drop_unknown_fields = true
  }
}

# -----------------------------------------------------------
# Networking Resources
# -----------------------------------------------------------

resource "google_compute_managed_ssl_certificate" "driplet_ssl_certificate" {
  name = "driplet-ssl-cert-${var.env}"
  managed {
    domains = [var.domain]
  }
}

resource "google_compute_network" "driplet_vpc_network" {
  project                 = var.project_id
  name                    = "driplet-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "driplet_vpc_subnet" {
  name          = "driplet-subnet"
  ip_cidr_range = var.subnetwork_cidr_range
  region        = var.region
  network       = google_compute_network.driplet_vpc_network.id
}

resource "google_compute_firewall" "ingress" {
  name    = "allow-http-https"
  network = google_compute_network.driplet_vpc_network.id
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_global_address" "new_loadbalancer_ip" {
  name = "loadbalancer-ip"
}

resource "google_compute_url_map" "driplet_url_map" {
  name = "driplet-url-map"

  host_rule {
    hosts        = ["*"]
    path_matcher = "catch-all"
  }

  path_matcher {
    name            = "catch-all"
    default_service = google_compute_backend_service.driplet_backend.self_link
  }

  default_url_redirect {
    https_redirect = true
    strip_query    = true
  }
}

resource "google_compute_target_http_proxy" "driplet_http_proxy" {
  name    = "http-proxy"
  url_map = google_compute_url_map.driplet_url_map.self_link
}

resource "google_compute_global_forwarding_rule" "driplet_http_forwarding_rule" {
  name                  = "driplet-http-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  target                = google_compute_target_http_proxy.driplet_http_proxy.self_link
  port_range            = "80"
  ip_address            = google_compute_global_address.new_loadbalancer_ip.address
}

resource "google_compute_target_https_proxy" "driplet_https_proxy" {
  name             = "driplet-https-proxy"
  url_map          = google_compute_url_map.driplet_url_map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.driplet_ssl_certificate.self_link]
}

resource "google_compute_global_forwarding_rule" "driplet_https_forwarding_rule" {
  name                  = "driplet-https-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  target                = google_compute_target_https_proxy.driplet_https_proxy.self_link
  port_range            = "443"
  ip_address            = google_compute_global_address.new_loadbalancer_ip.address
}

resource "google_compute_region_network_endpoint_group" "driplet_service_neg" {
  name                  = "driplet-service-neg"
  region                = var.region
  network_endpoint_type = "SERVERLESS"
  cloud_run {
    service = var.cloud_run_service_name
  }
}

resource "google_compute_backend_service" "driplet_backend" {
  name                  = "driplet-cloud-run-backend"
  load_balancing_scheme = "EXTERNAL"
  protocol              = "HTTP"
  backend {
    group = google_compute_region_network_endpoint_group.driplet_service_neg.id
  }
}

# -----------------------------------------------------------
# SQL Database Instance and SQL User
# -----------------------------------------------------------

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

resource "random_password" "driplet_application_db_password" {
  length    = 64
  special   = false
  min_upper = 5
  min_lower = 5
}

resource "google_sql_user" "driplet_application_db_user" {
  name     = "driplet_application_user"
  password = random_password.driplet_application_db_password.result
  instance = google_sql_database_instance.driplet_application_db.name
}

# -----------------------------------------------------------
# Compute / Cloud Run Resources
# -----------------------------------------------------------

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
        value = "postgresql://${var.database_user}:${random_password.driplet_application_db_password.result}@/postgres?host=/cloudsql/${google_sql_database_instance.driplet_application_db.connection_name}"
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
            secret  = google_secret_manager_secret.session_secret.secret_id
            version = "latest"
          }
        }
      }
      env {
        name = "GOOGLE_CLIENT_ID"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.oauth2_client_id.secret_id
            version = "latest"
          }
        }
      }
      env {
        name = "GOOGLE_CLIENT_SECRET"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.oauth2_client_secret.secret_id
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
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}
