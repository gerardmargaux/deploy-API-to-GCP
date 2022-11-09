# Create Artifact Registry Repository for Docker containers
resource "google_artifact_registry_repository" "my_docker_repo" {
  provider = google-beta

  location      = var.region
  repository_id = var.repository
  description   = "My docker repository"
  format        = "DOCKER"
  depends_on    = [time_sleep.wait_30_seconds]
}

# Create a Service Account
resource "google_service_account" "docker_pusher" {
  provider = google-beta

  account_id   = "docker-pusher"
  display_name = "Docker Container Pusher"
  depends_on   = [time_sleep.wait_30_seconds]
}

# Give Service Account permission to push to the Artifact Registry Repository
resource "google_artifact_registry_repository_iam_member" "docker_pusher_iam" {
  provider = google-beta

  location   = google_artifact_registry_repository.my_docker_repo.location
  repository = google_artifact_registry_repository.my_docker_repo.repository_id
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.docker_pusher.email}"
  depends_on = [
    google_artifact_registry_repository.my_docker_repo,
    google_service_account.docker_pusher
  ]
}