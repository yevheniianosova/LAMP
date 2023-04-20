resource "google_compute_health_check" "autohealing" {
  name                = "${var.instance_name}-autohealing-health-check"
  check_interval_sec  = var.check_interval_sec
  timeout_sec         = var.timeout_sec
  healthy_threshold   = var.healthy_threshold
  unhealthy_threshold = var.unhealthy_threshold
  
  tcp_health_check {
    port = var.healthcheckport
  }
}



resource "google_compute_instance_template" "instance" {
  name         = "${var.instance_name}-template"
  tags         = var.tags
  machine_type = var.machine_type
  disk {
    source_image = var.source_image
  }
  network_interface {
    network    = var.vpc_network_name 
    subnetwork = var.vpc_subnet_name  

  }
  service_account {
    email  = var.serviceaccountemail
    scopes = ["cloud-platform"]
  }
  metadata_startup_script = var.startup_script_path
}

resource "google_compute_region_instance_group_manager" "instance_group_manager" {
  name = "${var.instance_name}-instance-group-manager"
  version {
    instance_template = google_compute_instance_template.instance.id #var
  }

  base_instance_name        = var.instance_name #"httpserver"
  region                    = var.region
  distribution_policy_zones = ["${var.region}-c", "${var.region}-b"]
  # target_size               = var.quantity
  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.id
    initial_delay_sec = 1000
  }
  named_port {
    name = var.namedportname
    port = var.healthcheckport
  }
  depends_on = [google_compute_instance_template.instance]
}

resource "google_compute_region_autoscaler" "autoscaler" {
  name   = "${var.instance_name}-region-autoscaler"
  region = var.region
  target = google_compute_region_instance_group_manager.instance_group_manager.id

  autoscaling_policy {
    max_replicas    = 3
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}