# 🚀 Create a Pub/Sub Topic
resource "google_pubsub_topic" "gke_topic" {
  name    = var.pubsub_topic_name
  project = var.project_id
}

# 🚀 Create a Pull Subscription
resource "google_pubsub_subscription" "gke_pull_subscription" {
  name  = var.pubsub_subscription_name
  topic = google_pubsub_topic.gke_topic.name

  ack_deadline_seconds = 20

  retry_policy {
    minimum_backoff = "10s"
    maximum_backoff = "600s"
  }
}

# 🚀 Assign IAM Role for Pub/Sub Publisher to a Service Account
resource "google_pubsub_topic_iam_member" "pubsub_publisher" {
  topic  = google_pubsub_topic.gke_topic.name
  role   = "roles/pubsub.publisher"
  member = "serviceAccount:${var.service_account}"
}

# 🚀 Assign IAM Role for Pub/Sub Subscriber to a Service Account
resource "google_pubsub_subscription_iam_member" "pubsub_subscriber" {
  subscription = google_pubsub_subscription.gke_pull_subscription.name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.service_account}"
}
