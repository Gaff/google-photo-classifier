

resource "google_storage_bucket" "code_bucket" {
  name     = "${var.gcp_project}-code-bucket"
  location = "${var.gcp_region}"
  versioning {
    enabled = true
  }
}

resource "google_project_service" "pubsub" {
  project = var.gcp_project
  service = "pubsub.googleapis.com"
}

resource "google_pubsub_topic" "test-topic" {
  name = "my-test-topic"
}

