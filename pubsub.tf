data "google_pubsub_topic" "existing_topic" {
  name    = module.example_topic.topic 
  labels = local.labels
}

