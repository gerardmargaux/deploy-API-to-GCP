terraform {
  backend "gcs" {
    bucket = "bucket-tfstate-0c9bcfd30e66e323"
    prefix = "terraform/state"
  }
}