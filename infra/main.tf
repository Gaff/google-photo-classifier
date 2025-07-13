

resource "google_storage_bucket" "code_bucket" {
  name     = "${var.gcp_project}-code-bucket"
  location = "${var.gcp_region}"
  versioning {
    enabled = true
  }
}


resource "google_pubsub_topic" "test-topic" {
  name = "my-test-topic"
}

resource "google_storage_bucket" "photo_bucket" {
  name     = "${var.gcp_project}-photo-bucket"
  location = "${var.gcp_region}"
  lifecycle_rule {
    condition {
      age = 7
    }
    action {
      type = "Delete"
    }
  }
}

resource "google_pubsub_topic" "photo_topic" {
  name = "photo-topic"
}

resource "google_storage_notification" "photo_bucket_notification" { 
  depends_on = [ google_pubsub_topic_iam_binding.allow_service_agent_to_storage_publish ]
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

