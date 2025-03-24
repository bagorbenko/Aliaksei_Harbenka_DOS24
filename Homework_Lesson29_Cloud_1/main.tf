provider "google" {
  project = "oceanic-base-450915-k4"
  region  = "europe-west3"
}

resource "google_storage_bucket" "my_bucket" {
  name     = "my-bucket-tms3"
  location = "europe-west3"

  uniform_bucket_level_access = true
}
