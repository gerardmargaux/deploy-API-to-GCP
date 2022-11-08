terraform {
 backend "gcs" {
   bucket  = "bucket-tfstate-187356243"
   prefix  = "terraform/state"
 }
}