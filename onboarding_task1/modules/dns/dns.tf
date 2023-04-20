resource "google_compute_global_address" "lb-static-ip" {
  name = "staticip"
}
resource "google_compute_address" "kibana-static-ip" {
  name = "kibana-static-ip"
  region  = var.region
}
resource "google_compute_address" "bastion-static-ip" {
  name = "bastion-static-ip"
  region = var.region
}

resource "google_compute_managed_ssl_certificate" "sslCertificate" {
  name = "google-cert"

  managed {
    domains = ["${var.domain}.", "www.${var.domain}."]
  }
  
}

resource "google_dns_managed_zone" "dnszone" {
  name     = "dnszone"
  dns_name = "${var.domain}."
}

resource "google_dns_record_set" "cname" {
  name         = "www.${var.domain}."
  managed_zone = google_dns_managed_zone.dnszone.name
  type         = "CNAME"
  ttl          = 300
  rrdatas      = ["${var.domain}."]
}

resource "google_dns_record_set" "dnsrecords" {
  managed_zone = google_dns_managed_zone.dnszone.name
  name         = "${var.domain}."
  type         = "A"
  rrdatas      = [google_compute_global_address.lb-static-ip.address]
  ttl          = 300
  depends_on = [google_compute_global_address.lb-static-ip]
}

resource "google_dns_record_set" "dnsrecords_kibana" {
  managed_zone = google_dns_managed_zone.dnszone.name
  name         = "kibana.${var.domain}."
  type         = "A"
  rrdatas      = [google_compute_address.kibana-static-ip.address]
  ttl          = 300
  depends_on = [google_compute_address.kibana-static-ip]
}



#https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map




# resource "google_compute_address" "lb-static-ip" {
#   name         = "lb-static-ip"
#   address_type = "EXTERNAL"
#   network_tier = "STANDARD"
#   region       = "us-"
# }

#dns sslcert 2 мапи і 2 форвард рула(80 на 443 автоматік) юрл мапи 2 шттпс проксі з сертифікатомт