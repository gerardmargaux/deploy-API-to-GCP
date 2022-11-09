terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.25.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_project_service" "gcp_resource_manager_api" {
  project = var.project_id
  service = "cloudresourcemanager.googleapis.com"
}

resource "time_sleep" "gcp_wait_crm_api_enabling" {
  depends_on = [
    google_project_service.gcp_resource_manager_api
  ]
  create_duration = "1m"
}

# Enable storage API
resource "google_project_service" "storage" {
  provider           = google
  service            = "storage.googleapis.com"
  disable_on_destroy = false
}

# This is used so there is some time for the activation of the API's to propagate through 
# Google Cloud before actually calling them.
resource "time_sleep" "wait_30_seconds" {
  create_duration = "30s"
  depends_on      = [google_project_service.storage]
}

// Terraform plugin for creating random IDs
resource "random_id" "instance_id" {
  byte_length = 8
}

resource "google_storage_bucket" "default" {
  name          = "bucket-tfstate-${random_id.instance_id.hex}"
  force_destroy = false
  location      = var.region
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
  depends_on = [time_sleep.wait_30_seconds]
}

output "bucket_name" {
  description = "Terraform backend bucket name"
  value       = google_storage_bucket.default.name
}