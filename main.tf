# 🚀 Create Pub/Sub Topic
resource "google_pubsub_topic" "topic" {
  name = var.topic_name
}

# 🚀 Create a Pull Subscription
resource "google_pubsub_subscription" "pull_subscription" {
  name  = var.subscription_name
  topic = google_pubsub_topic.topic.name

  ack_deadline_seconds = 20

  retry_policy {
    minimum_backoff = "10s"
    maximum_backoff = "600s"
  }
}

# 🚀 Create a Push Subscription (Optional)
resource "google_pubsub_subscription" "push_subscription" {
  name  = "${var.subscription_name}-push"
  topic = google_pubsub_topic.topic.name

  push_config {
    push_endpoint = var.push_endpoint
  }
}

# 🚀 Grant IAM Role to a Service Account
resource "google_pubsub_topic_iam_member" "pubsub_publisher" {
  topic  = google_pubsub_topic.topic.name
  role   = "roles/pubsub.publisher"
  member = "serviceAccount:my-service-account@${var.project_id}.iam.gserviceaccount.com"
}

resource "google_pubsub_subscription_iam_member" "pubsub_subscriber" {
  subscription = google_pubsub_subscription.pull_subscription.name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:my-service-account@${var.project_id}.iam.gserviceaccount.com"
}
