resource "google_secret_manager_secret" "elasticsearch-ca-crt" {
  secret_id = "elasticsearch-ca-crt"
  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret" "elasticsearch-ca-key" {
  secret_id = "elasticsearch-ca-key"
  replication {
    automatic = true
  }
}
# resource "google_secret_manager_secret_version" "elasticsearch-ca" {
#   secret = google_secret_manager_secret.elasticsearch-ca.id

#   secret_data = "secret-data"
# }

resource "google_secret_manager_secret" "elasticsearch-certificate-crt" {
  secret_id = "elasticsearch-certificate-crt"
  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret" "elasticsearch-certificate-key" {
  secret_id = "elasticsearch-certificate-key"
  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret" "kibana-certificate-pem" {
  secret_id = "kibana-certificate-pem"
  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret" "kibana-password" {
  secret_id = "kibana-password"
  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret" "elastic-password" {
  secret_id = "elastic-password"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret" "logstash-password" {
  secret_id = "logstash-password"
  replication {
    automatic = true
  }
}

# resource "google_secret_manager_secret" "beats-password" {
#   secret_id = "beats-password"
#   replication {
#     automatic = true
#   }
# }

resource "google_secret_manager_secret" "oauth-github-client-id" {
  secret_id = "oauth-github-client-id"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret" "oauth-github-client-secret" {
  secret_id = "oauth-github-client-secret"
  replication {
    automatic = true
  }
}
# resource "google_secret_manager_secret_version" "elasticsearch-certificate-p12" {
#   secret = google_secret_manager_secret.elasticsearch-certificate-p12.id

#   secret_data = "secret-data"
# }