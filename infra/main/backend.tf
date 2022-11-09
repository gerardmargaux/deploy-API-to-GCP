terraform {
  backend "gcs" {
    bucket = "bucket-tfstate-f708fe1a360136f7"
    prefix = "terraform/state"
  }
}