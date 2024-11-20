# SSL Certificate
resource "google_compute_managed_ssl_certificate" "driplet_ssl_cert" {
  name = "driplet-ssl-cert"

  managed {
    domains = [var.domain]
  }
}

# VPC Network
resource "google_compute_network" "driplet_vpc_network" {
  project                 = var.project_id
  name                    = "driplet-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# Subnetwork
resource "google_compute_subnetwork" "driplet_vpc_subnet" {
  name          = "driplet-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.driplet_vpc_network.id
}

# Firewall Rule for HTTP and HTTPS
resource "google_compute_firewall" "ingress" {
  name    = "allow-http-https"
  network = google_compute_network.driplet_vpc_network.id
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
}

# Load Balancer IP Address
resource "google_compute_global_address" "new_loadbalancer_ip" {
  name = "loadbalancer-ip"
}

# URL Map
resource "google_compute_url_map" "driplet_url_map" {
  name = "driplet-url-map"

  host_rule {
    hosts        = ["*"]
    path_matcher = "catch-all"
  }

  path_matcher {
    name            = "catch-all"
    default_service = google_compute_backend_service.driplet_backend.self_link
  }

  default_url_redirect {
    https_redirect = true
    strip_query    = true
  }
}

# HTTP Proxy
resource "google_compute_target_http_proxy" "driplet_http_proxy" {
  name    = "http-proxy"
  url_map = google_compute_url_map.driplet_url_map.self_link
}

# HTTP Forwarding Rule
resource "google_compute_global_forwarding_rule" "driplet_http_forwarding_rule" {
  name                  = "driplet-http-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  target                = google_compute_target_http_proxy.driplet_http_proxy.self_link
  port_range            = "80"
  ip_address            = google_compute_global_address.new_loadbalancer_ip.address
}

# HTTPS Proxy
resource "google_compute_target_https_proxy" "driplet_https_proxy" {
  name             = "driplet-https-proxy"
  url_map          = google_compute_url_map.driplet_url_map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.driplet_ssl_cert.self_link]
}

# HTTPS Forwarding Rule
resource "google_compute_global_forwarding_rule" "driplet_https_forwarding_rule" {
  name                  = "driplet-https-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  target                = google_compute_target_https_proxy.driplet_https_proxy.self_link
  port_range            = "443"
  ip_address            = google_compute_global_address.new_loadbalancer_ip.address
}

# Network Endpoint Group for Cloud Run
resource "google_compute_region_network_endpoint_group" "driplet_service_neg" {
  name                  = "driplet-service-neg"
  region                = var.region
  network_endpoint_type = "SERVERLESS"
  cloud_run {
    service = var.cloud_run_service_name
  }
}

# Backend Service
resource "google_compute_backend_service" "driplet_backend" {
  name                  = "driplet-cloud-run-backend"
  load_balancing_scheme = "EXTERNAL"
  protocol              = "HTTP"

  backend {
    group = google_compute_region_network_endpoint_group.driplet_service_neg.id
  }
}
