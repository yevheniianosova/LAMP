resource "google_compute_network" "vpc_network" {
  # project                 = var.project_name
  name                    = var.vpc_network_name
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
  mtu = 1460

}
resource "google_compute_subnetwork" "vpc_public_subnet" {
  name          = var.vpc_public_subnet_name ## variable vpc_subnet_name
  ip_cidr_range = var.IP_range_public
  # region = var.region
  network                  = google_compute_network.vpc_network.id ##variable vpc_network_name  
  stack_type               = "IPV4_ONLY"
  private_ip_google_access = true ##variable isprivate
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    metadata             = "INCLUDE_ALL_METADATA"
  }
}
resource "google_compute_subnetwork" "vpc_private_subnet" {
  name          = var.vpc_private_subnet_name    ## variable vpc_subnet_name
  ip_cidr_range = var.IP_range_private ## variable IP_range
  network = google_compute_network.vpc_network.id ##variable vpc_network_name
  private_ip_google_access = true ##variable isprivate
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    metadata             = "INCLUDE_ALL_METADATA"
  }
}


resource "google_compute_instance" "bastionhost" {
  name         = "bastionhost"
  machine_type = "e2-micro"
  zone         = "${var.region}-b" ##var instance_zone
  tags         = ["bastionhost"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 10
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id         ##variable vpc_network_name
    subnetwork = var.vpc_public_subnet_name ## variable vpc_subnet_name
    access_config {
        nat_ip = "${var.bastion-static-ip}"
    }
  }
  metadata_startup_script = <<SCRIPT
sudo cat << "EOF" >> /etc/ssh/sshd_config 
port 4757
#ListenAddress 0.0.0.0/0

PermitTTY no
X11Forwarding no
PermitTunnel no
GatewayPorts no

#ForceCommand /usr/sbin/nologin
    
EOF
sudo systemctl restart sshd.service
SCRIPT
}

resource "google_compute_firewall" "allow-ssh" {
  name      = "allow-ssh-bastion"          ##variable firewall_rule_name
  network   = google_compute_network.vpc_network.id ##variable vpc_network_name
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["4757"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["bastionhost"]
}

resource "google_compute_firewall" "allow-ssh-resources" {

  name      = "allow-ssh-resources"   ##variable firewall_rule_name
  network   = google_compute_network.vpc_network.id ##variable vpc_network_name
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_tags = ["bastionhost"]
  target_tags = ["httpserver","packerimage","kibana","logstash","elastic"]
}
resource "google_compute_firewall" "allow-elastic-httpserver" {

  name      = "allow-elastic-httpservere"     ##variable firewall_rule_name
  network   = google_compute_network.vpc_network.id ##variable vpc_network_name
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["9200","5601","5044","9300","9600"]
  }

  source_tags = ["httpserver","kibana","logstash","elastic"]
  target_tags = ["httpserver","kibana","logstash","elastic"]

}
resource "google_compute_firewall" "default" {
  name = "fw-allow-health-check"
  allow {
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc_network.id
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["httpserver","elastic","kibana","logstash"]
}
resource "google_compute_firewall" "allow-database" {

  name      = "allow-database"     ##variable firewall_rule_name
  network   = google_compute_network.vpc_network.id ##variable vpc_network_name
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }

  source_tags = ["httpserver"]

}
resource "google_compute_router" "router" {
  name    = "router"
  network = google_compute_network.vpc_network.id
}
resource "google_compute_router_nat" "nat" {
  name                               = "nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}



# allow-icmp

# kibana logstash
# elk
# resource "google_compute_firewall" "allow-ssh-packer" {

#   name      = "allow-ssh-packer"   ##variable firewall_rule_name
#   network   = google_compute_network.vpc_network.id ##variable vpc_network_name
#   direction = "INGRESS"

#   allow {
#     protocol = "tcp"
#     ports    = ["22"]
#   }
#   # source_ranges  = ["0.0.0.0/0"]
#   source_tags = ["bastionhost"]
#   target_tags = ["packerimage"]
# }
