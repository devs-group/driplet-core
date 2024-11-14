resource "google_secret_manager_secret" "session-secret" {
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

resource "google_secret_manager_secret_iam_member" "session-auth-secret" {
  secret_id  = google_secret_manager_secret.session-secret.id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${google_service_account.driplet_service_account.email}"
  depends_on = [google_secret_manager_secret.session-secret]
}

resource "google_secret_manager_secret" "oauth2-client-secret" {
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

resource "google_secret_manager_secret_iam_member" "oauth2-client-secret" {
  secret_id  = google_secret_manager_secret.oauth2-client-secret.id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${google_service_account.driplet_service_account.email}"
  depends_on = [google_secret_manager_secret.oauth2-client-secret]
}

resource "google_secret_manager_secret" "oauth2-client-id" {
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

resource "google_secret_manager_secret_iam_member" "oauth2-client-id" {
  secret_id  = google_secret_manager_secret.oauth2-client-id.id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${google_service_account.driplet_service_account.email}"
  depends_on = [google_secret_manager_secret.oauth2-client-id]
}