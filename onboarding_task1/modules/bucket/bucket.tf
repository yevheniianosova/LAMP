resource "google_storage_bucket" "bucket" {
  name                        = var.bucketname
  location                    = var.location
  force_destroy               = true
  uniform_bucket_level_access = true
  # logging {
  #   log_bucket = google_storage_bucket.access_logs.name

  # }
}

##restart_bucket
