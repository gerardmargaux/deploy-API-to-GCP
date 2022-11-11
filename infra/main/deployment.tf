# Deploy image to Cloud Run
resource "google_cloud_run_service" "api_test" {
  provider = google-beta
  count    = var.first_time ? 0 : 1
  name     = "api-test"
  location = var.region
  template {
    spec {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repository}/${var.docker_image}"
        ports {
          container_port = 5000
        }
        resources {
          limits = {
            cpu = "1"
            memory = "4G"
          }
        }
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = "1"
        "autoscaling.knative.dev/maxScale" = "1"
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
  depends_on = [google_artifact_registry_repository_iam_member.docker_pusher_iam]
}

# Create a policy that allows all users to invoke the API
data "google_iam_policy" "noauth" {
  provider = google-beta
  count    = var.first_time ? 0 : 1
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

# Apply the no-authentication policy to our Cloud Run Service.
resource "google_cloud_run_service_iam_policy" "noauth" {
  count    = var.first_time ? 0 : 1
  provider = google-beta
  location = var.region
  project  = var.project_id
  service  = google_cloud_run_service.api_test[0].name

  policy_data = data.google_iam_policy.noauth[0].policy_data
}

output "cloud_run_instance_url" {
  value = var.first_time ? null : google_cloud_run_service.api_test[0].status.0.url
}