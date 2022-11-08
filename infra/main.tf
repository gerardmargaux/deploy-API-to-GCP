terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.25.0"
    }
  }

}

provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Create bucket to store terraform state 
resource "google_storage_bucket" "default" {
  name          = "bucket-tfstate-187356243"
  force_destroy = false
  location      = "US"
  storage_class = "STANDARD"
  project       = var.project_id
  versioning {
    enabled = true
  }
}

# Enable IAM API
resource "google_project_service" "iam" {
  provider           = google-beta
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

# Enable Artifact Registry API
resource "google_project_service" "artifactregistry" {
  provider           = google-beta
  service            = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}

# Enable Cloud Run API
resource "google_project_service" "cloudrun" {
  provider           = google-beta
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

# Enable Cloud Resource Manager API
resource "google_project_service" "resourcemanager" {
  provider           = google-beta
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

# This is used so there is some time for the activation of the API's to propagate through
# Google Cloud before actually calling them.
resource "time_sleep" "wait_30_seconds" {
  create_duration = "30s"
  depends_on = [
    google_project_service.iam,
    google_project_service.artifactregistry,
    google_project_service.cloudrun,
    google_project_service.resourcemanager
  ]
}

# Create Artifact Registry Repository for Docker containers
resource "google_artifact_registry_repository" "my_docker_repo" {
  provider      = google-beta
  location      = var.region
  repository_id = var.repository
  description   = "My docker repository"
  format        = "DOCKER"
  depends_on    = [time_sleep.wait_30_seconds]
}

# Create a service account
resource "google_service_account" "docker_pusher" {
  provider     = google-beta
  account_id   = "docker-pusher"
  display_name = "Docker Container Pusher"
  depends_on   = [time_sleep.wait_30_seconds]
}

# Give service account permission to push to the Artifact Registry Repository
resource "google_artifact_registry_repository_iam_member" "docker_pusher_iam" {
  provider   = google-beta
  location   = google_artifact_registry_repository.my_docker_repo.location
  repository = google_artifact_registry_repository.my_docker_repo.repository_id
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.docker_pusher.email}"
  depends_on = [
    google_artifact_registry_repository.my_docker_repo,
    google_service_account.docker_pusher
  ]
}