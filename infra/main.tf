terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  backend "gcs" {
    bucket = "${var.gcp_project}-terraform-state"
    prefix = "terraform/state"
  }

}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}


resource "google_compute_network" "vpc" {
  name                    = "gpc-vpc"
  auto_create_subnetworks = false
}

variable "gcp_project" {
}
variable "gcp_region" {
  default = "europe-west2"
}

