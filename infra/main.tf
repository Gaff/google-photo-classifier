

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

