# Enable IAM API
resource "google_project_service" "iam" {
  provider           = google
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

# Enable Artifact Registry API
resource "google_project_service" "artifactregistry" {
  provider           = google
  service            = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}

# Enable Cloud Run API
resource "google_project_service" "cloudrun" {
  provider           = google
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

# Enable Cloud Resource Manager API
resource "google_project_service" "resourcemanager" {
  provider           = google
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

# This is used so there is some time for the activation of the API's to propagate through 
# Google Cloud before actually calling them.
resource "time_sleep" "wait_30_seconds" {
  create_duration = "30s"
  depends_on = [
    google_project_service.artifactregistry,
    google_project_service.cloudrun,
    google_project_service.resourcemanager
  ]
}