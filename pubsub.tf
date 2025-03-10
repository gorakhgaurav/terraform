provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_pubsub_topic" "existing_topic" {
  name    = module.example_topic.topic 
  labels = local.labels
}

