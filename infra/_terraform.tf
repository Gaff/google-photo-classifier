terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  backend "gcs" {
    # Passed via -backend-config
    #bucket = "${var.gcp_project}-terraform-state"
    prefix = "terraform/state"
  }

}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}


variable "gcp_project" {
}
variable "gcp_region" {
  default = "europe-west2"
}
