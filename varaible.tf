variable "pubsub_topic_name" {
  description = "Name of the Pub/Sub topic"
  type        = string
}

variable "pubsub_subscription_name" {
  description = "Name of the Pub/Sub subscription"
  type        = string
}

variable "push_endpoint" {
  description = "Endpoint URL for push subscription"
  type        = string
  default     = "https://example.com/push-endpoint"
}

variable "service_account" {
  description = "Service account email for Pub/Sub access"
  type        = string
}
