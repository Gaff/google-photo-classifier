data "google_project" "gcp_project" { 
  project_id = var.gcp_project 
}

locals {
  services = [
    "pubsub.googleapis.com",
    "cloudfunctions.googleapis.com",
    "run.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudvision.googleapis.com",
  ]
}

resource "google_project_service" "services" {
  # Bit of a gotcha but requires a delay before it goes live!
  for_each = toset(local.services)
  project = var.gcp_project
  service = each.value
}

