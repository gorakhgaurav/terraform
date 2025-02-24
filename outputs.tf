output "pubsub_topic" {
  value = google_pubsub_topic.topic.name
}

output "pull_subscription" {
  value = google_pubsub_subscription.pull_subscription.name
}

output "push_subscription" {
  value = google_pubsub_subscription.push_config
}
