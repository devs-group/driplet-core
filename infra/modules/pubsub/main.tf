# Create a Pub/Sub topic
resource "google_pubsub_topic" "client_events" {
  name    = var.topic_name_client_events
  project = var.project_id

  message_retention_duration = "604800s" # 7 days

}

# Pub/Sub Subscription with BigQuery as a subscriber
resource "google_pubsub_subscription" "bigquery_subscription" {
  name  = var.subscription_name
  topic = google_pubsub_topic.client_events.id

  project = var.project_id

  ack_deadline_seconds       = 600       # 10 minutes
  message_retention_duration = "604800s" # 7 days

  bigquery_config {
    table               = "${var.project_id}.${var.bigquery_dataset}.${var.bigquery_table}"
    write_metadata      = false
    drop_unknown_fields = true
  }
}