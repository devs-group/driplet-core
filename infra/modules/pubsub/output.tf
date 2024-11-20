output "subscription_name" {
  description = "The name of the Pub/Sub subscription"
  value       = google_pubsub_subscription.bigquery_subscription.name
}

output "subscription_topic" {
  description = "The topic linked to the subscription"
  value       = google_pubsub_subscription.bigquery_subscription.topic
}