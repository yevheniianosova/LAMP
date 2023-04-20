
resource "google_compute_global_address" "private_ip_addr" {
  name          = "private-ip-addr"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.network
}

resource "google_service_networking_connection" "vpc_connection" {
  network                 = var.network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_addr.name]
}

resource "google_service_networking_connection" "replica_vpc" {

  network                 = var.network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_addr.name]

}

resource "google_sql_database_instance" "databaseinstance" {
  name                = var.db_name
  database_version    = "MYSQL_5_7"
  region              = var.region
  depends_on          = [google_service_networking_connection.vpc_connection] #[var.network]
  deletion_protection = false
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = false
      # authorized_networks {
      #   name = "ALL"
      #   value = "0.0.0.0/0"

      # }
      private_network = var.network
    }
    backup_configuration {
      enabled            = true
      binary_log_enabled = true
    }
  }
}

resource "google_sql_database_instance" "readreplica" {
  name                 = "${var.db_name}-failover"
  master_instance_name = google_sql_database_instance.databaseinstance.name
  database_version     = "MYSQL_5_7"
  region               = var.region
  deletion_protection  = false

  depends_on = [google_service_networking_connection.replica_vpc] ##[var.network]

  replica_configuration {
    failover_target = true
  }
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = false
      # authorized_networks {
      #   name = "ALL"
      #   value = "0.0.0.0/0"
      # }
      private_network = var.network
    }
    backup_configuration {
      enabled = false
    }
  }
}
resource "google_sql_database" "database" {
  name     = var.db_name
  instance = google_sql_database_instance.databaseinstance.name
}

resource "google_sql_user" "users" {
  name       = var.db_user
  instance   = google_sql_database_instance.databaseinstance.name
  host       = "%"
  password   = var.password
  depends_on = [google_sql_database_instance.databaseinstance]
}

