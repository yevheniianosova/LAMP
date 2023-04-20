output "healthcheck" {
  value = google_compute_health_check.autohealing.id
}
output "instancegroup" {
  value = google_compute_region_instance_group_manager.instance_group_manager.instance_group
}