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


#############Filestore#######

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "filestore_name" {
  description = "The name of the Filestore instance"
  type        = string
}

variable "zone" {
  description = "The GCP zone where the Filestore instance will be created"
  type        = string
}

variable "tier" {
  description = "The Filestore service tier (STANDARD, PREMIUM, ENTERPRISE)"
  type        = string
}

variable "network" {
  description = "The name of the VPC network to which the Filestore instance is connected"
  type        = string
}

variable "share_name" {
  description = "The name of the file share"
  type        = string
}

variable "capacity_gb" {
  description = "The storage capacity of the file share in GB"
  type        = number
}
variable "keys" {
  description = "The full resource name of the KMS key used to encrypt the Filestore instance"
  type        = string
}

######### RBAC



variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "Region where GKE cluster is deployed"
  type        = string
}

variable "gke_service_account" {
  description = "Service account email for GKE nodes"
  type        = string
}

variable "gke_admin_user" {
  description = "User who will be given Kubernetes admin access"
  type        = string
}
variable "namespaces" {
  description = "List of namespaces for user-group read-only access"
  type        = list(string)
}
