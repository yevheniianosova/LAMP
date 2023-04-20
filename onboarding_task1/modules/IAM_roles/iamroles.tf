
resource "google_service_account" "SA" {
  account_id   = "custom-compute-sa"
  display_name = "Bucket Service Account"
}

resource "google_storage_bucket_iam_member" "bucket-server-link" {
  bucket = var.bucketid
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.SA.email}" #}@gcp101845-educoeynoso.iam.gserviceaccount.com
}

resource "google_project_iam_binding" "monitoring" { #rename
  project = var.project
  role    = "roles/monitoring.metricWriter"
  members = [
    "serviceAccount:${google_service_account.SA.email}"
  ]
}

resource "google_project_iam_binding" "logging" { #rename
  project = var.project
  role    = "roles/logging.logWriter"
  members = [
    "serviceAccount:${google_service_account.SA.email}"
  ]
}

resource "google_project_iam_binding" "compute-instances-viewer" {
  project = var.project
  role    = "roles/compute.viewer"
  members = [
    "serviceAccount:${google_service_account.SA.email}"
  ]
}

resource "google_project_iam_binding" "secrets-admin" {
  project = var.project
  role = "roles/secretmanager.admin"
  members = [
    "serviceAccount:${google_service_account.SA.email}"
  ]
}

resource "google_service_account" "packerSA" {
  account_id   = "packersa-id"
  display_name = "Packer Service Account"
}

data "google_iam_policy" "packer" {
  binding {
    role    = "roles/compute.instanceAdmin"
    members = ["serviceAccount:${google_service_account.SA.email}"]
  }
}

resource "google_service_account_key" "mykey" {
  service_account_id = google_service_account.packerSA.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}
