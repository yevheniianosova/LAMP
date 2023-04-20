resource "google_compute_backend_service" "wpbackend" {
  name          = "wpbackend"
  health_checks = [var.healthcheck]
  backend {
    group           = var.instancegroup
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
    max_utilization = 1
  }

}

resource "google_compute_url_map" "urlmap" {
  name            = "urlmap"
  default_service = google_compute_backend_service.wpbackend.id
}
#https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map
resource "google_compute_target_https_proxy" "httpsProxy" {
  name             = "proxy"
  url_map          = google_compute_url_map.urlmap.id
  ssl_certificates = [var.SSLCert]
}

resource "google_compute_global_forwarding_rule" "load-balancer-rule" {
  name       = "https-forwarding-rule"
  ip_address = var.staticIP
  port_range = "443"
  target     = google_compute_target_https_proxy.httpsProxy.id
}


resource "google_compute_global_forwarding_rule" "http-redirect" {
  name       = "http-forwarding-rule"
  target     = google_compute_target_http_proxy.http-redirect.self_link
  ip_address = var.staticIP
  port_range = "80"
}


resource "google_compute_url_map" "http-redirect" {
  name = "http-redirect"
  default_url_redirect {
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
    https_redirect         = true
  }
}

resource "google_compute_target_http_proxy" "http-redirect" {
  name    = "http-redirect"
  url_map = google_compute_url_map.urlmap.self_link
}


#dns sslcert 2 мапи і 2 форвард рула(80 на 443 автоматік) юрл мапи 2 шттпс проксі з сертифікатомт