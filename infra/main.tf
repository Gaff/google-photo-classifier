data "google_project" "gcp_project" { 
  project_id = var.gcp_project 
}

resource "google_storage_bucket" "code_bucket" {
  name     = "${var.gcp_project}-code-bucket"
  location = "${var.gcp_region}"
  versioning {
    enabled = true
  }
}



locals {
  services = [
    "pubsub.googleapis.com",
    "cloudfunctions.googleapis.com",
    "run.googleapis.com",
    "cloudbuild.googleapis.com",
  ]
}

resource "google_project_service" "services" {
  # Bit of a gotcha but requires a delay before it goes live!
  for_each = toset(local.services)
  project = var.gcp_project
  service = each.value
}

resource "google_pubsub_topic" "test-topic" {
  name = "my-test-topic"
}

resource "google_storage_bucket" "photo_bucket" {
  name     = "${var.gcp_project}-photo-bucket"
  location = "${var.gcp_region}"
  retention_policy {
    # 1 week:
    retention_period = "604800s" # 1 week
    # retention_period = "86400s" # 1 day 
  }
}

resource "google_pubsub_topic" "photo-topic" {
  name = "photo-topic"
}

resource "google_storage_notification" "photo_bucket_notification" { 
  bucket = google_storage_bucket.photo_bucket.name 
  topic = google_pubsub_topic.photo_topic.id 
  event_types = ["OBJECT_FINALIZE"] 
  payload_format = "JSON_API_V1"
}

resource "google_pubsub_subscription" "photo_monitoring_subscription" { 
  name = "photo-topic-monitoring-sub" 
  topic = google_pubsub_topic.photo_topic.name 
  ack_deadline_seconds = 30 
  message_retention_duration = "14400s" # 4 hours 
  retain_acked_messages = true 
}

resource "google_pubsub_topic_iam_binding" "allow_service_agent_to_storage_publish" { 
  topic = google_pubsub_topic.photo_topic.name 
  role = "roles/pubsub.publisher" 
  members = [ "serviceAccount:service-${data.google_project.gcp_project.number}@gs-project-accounts.iam.gserviceaccount.com", ] 
}
