output "lb-static-ip" {
  value = google_compute_global_address.lb-static-ip.address
}
output "SSLcert" {
  value = google_compute_managed_ssl_certificate.sslCertificate.id
}
output "kibana-static-ip" {
  value = google_compute_address.kibana-static-ip.address
}
output "bastion-static-ip" {
  value = google_compute_address.bastion-static-ip.address
}