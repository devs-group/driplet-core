# Session Secret
resource "google_secret_manager_secret" "session_secret" {
  labels    = { component = "driplet", managed = "terraform" }
  project   = var.project_id
  secret_id = "session-secret"

  replication {
    user_managed {
      replicas {
        location = "europe-west1"
      }
    }
  }
}

resource "google_secret_manager_secret_iam_member" "session_auth_secret" {
  secret_id  = google_secret_manager_secret.session_secret.id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${var.service_account_email}"
  depends_on = [google_secret_manager_secret.session_secret]
}

# OAuth2 Client Secret
resource "google_secret_manager_secret" "oauth2_client_secret" {
  labels    = { component = "driplet", managed = "terraform" }
  project   = var.project_id
  secret_id = "oauth2-client-secret"

  replication {
    user_managed {
      replicas {
        location = "europe-west1"
      }
    }
  }
}

resource "google_secret_manager_secret_iam_member" "oauth2_client_secret_member" {
  secret_id  = google_secret_manager_secret.oauth2_client_secret.id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${var.service_account_email}"
  depends_on = [google_secret_manager_secret.oauth2_client_secret]
}

# OAuth2 Client ID
resource "google_secret_manager_secret" "oauth2_client_id" {
  labels    = { component = "driplet", managed = "terraform" }
  project   = var.project_id
  secret_id = "oauth2-client-id"

  replication {
    user_managed {
      replicas {
        location = "europe-west1"
      }
    }
  }
}

resource "google_secret_manager_secret_iam_member" "oauth2_client_id_member" {
  secret_id  = google_secret_manager_secret.oauth2_client_id.id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${var.service_account_email}"
  depends_on = [google_secret_manager_secret.oauth2_client_id]
}
