variable "project_id" {
  description = "The name of the project"
  type        = string
  default     = "deploy-404001"
}

variable "region" {
  description = "The default compute region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The default compute zone"
  type        = string
  default     = "us-central1"
}

variable "repository" {
  description = "The name of the Artifact Registry repository to be created"
  type        = string
  default     = "docker-repository"
}

variable "docker_image" {
  description = "The name of the Docker image in the Artifact Registry repository to be deployed to Cloud Run"
  type        = string
  default     = "deploy"
}

variable "first_time" {
  description = "Boolean flag to indicate if this is the first time the application is running. If so, the cloud run step is omitted"
  type        = bool
  default     = false
}