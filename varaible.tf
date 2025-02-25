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
variable "disk_name" {
  description = "Name of the persistent disk"
  type        = string
  default     = "gke-block-storage"
}

variable "disk_type" {
  description = "Type of persistent disk (pd-standard, pd-ssd, pd-balanced)"
  type        = string
  default     = "pd-balanced"
}

variable "disk_size" {
  description = "Size of the persistent disk in GB"
  type        = number
  default     = 50
}

variable "zone" {
  description = "GCP Zone for the disk"
  type        = string
  default     = "us-central1-a"
}
