output "vpc_network" {
  value = google_compute_network.vpc_network.id
}
output "private_vpc_network" {
  value = google_compute_network.vpc_network.id
}
output "vpc_private_subnet" {
  value = google_compute_subnetwork.vpc_private_subnet.id
}
