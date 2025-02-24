resource "google_container_cluster" "autopilot_cluster" {
  name     = var.cluster_name
  project  = var.project_id
  location = var.region
  network  = var.network
  subnetwork = "projects/${var.network_project}/regions/${var.region}/subnetworks/${var.subnetwork}"

  initial_node_count = var.initial_node_count
  enable_autopilot   = true
  deletion_protection = false
  networking_mode = var.networking_mode
  private_ipv6_google_access = "PRIVATE_IPV6_GOOGLE_ACCESS_DISABLED"

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  control_plane_endpoints_config {
    dns_endpoint_config {
      allow_external_traffic = false
    }
  }

  enterprise_config {
    desired_tier = "ENTERPRISE"
  }
}

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

# 🚀 Create a Push Subscription (Optional)
resource "google_pubsub_subscription" "gke_push_subscription" {
  name  = "${var.pubsub_subscription_name}-push"
  topic = google_pubsub_topic.gke_topic.name

  push_config {
    push_endpoint = var.push_endpoint
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
