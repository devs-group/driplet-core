resource "google_artifact_registry_repository" "driplet-registry" {
  location      = var.region
  project       = var.project_id
  repository_id = "driplet-repository"
  description   = "Driplet Repository"
  format        = "DOCKER"
  cleanup_policies {
    id     = "delete_old_images"
    action = "DELETE"
    condition {
      older_than = "432000s"
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