resource "google_compute_managed_ssl_certificate" "driplet_ssl_cert" {
  name = "driplet-ssl-cert"

  managed {
    domains = ["driplet.codify.ch"]
  }
}

resource "google_compute_network" "driplet_vpc_network" {
  project                 = var.project_id
  name                    = "driplet-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "driplet_vpc_subnet" {
  name          = "driplet-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.driplet_vpc_network.id
}

#resource "google_compute_global_address" "driplet_db" {
#  name          = "driplet-db-ip"
#  address_type  = "INTERNAL"
#  purpose       = "VPC_PEERING"
#  prefix_length = 16
#  network       = google_compute_network.driplet_vpc_network.id
#}

#resource "google_service_networking_connection" "driplet_connection" {
#  network                 = google_compute_network.driplet_vpc_network.id
#  reserved_peering_ranges = [google_compute_global_address.driplet_db.name]
#  service                 = "servicenetworking.googleapis.com"
#}

resource "google_compute_firewall" "ingress" {
  name    = "allow-http-https"
  network = google_compute_network.driplet_vpc_network.id
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_global_address" "new_loadbalancer_ip" {
  name = "loadbalancer-ip"
}

resource "google_compute_url_map" "driplet_url_map" {
  name = "driplet-url-map"

  host_rule {
    hosts        = ["*"]
    path_matcher = "catch-all"
  }

  path_matcher {
    name            = "catch-all"
    default_service = google_compute_backend_service.driplet_driplet.self_link
    #path_rule {
    #  paths = ["/monitoring", "/monitoring/*"]
    #  service = google_compute_backend_service.driplet_cloud_run_monitoring.self_link
    #}
  }

  default_url_redirect {
    https_redirect = true
    strip_query    = true
  }
}

resource "google_compute_target_http_proxy" "driplet_http_proxy" {
  name    = "http-proxy"
  url_map = google_compute_url_map.driplet_url_map.self_link
}


resource "google_compute_global_forwarding_rule" "driplet_http_forwarding_rule" {
  name                  = "driplet-http-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  target                = google_compute_target_http_proxy.driplet_http_proxy.self_link
  port_range            = "80"
  ip_address            = google_compute_global_address.new_loadbalancer_ip.address
}

resource "google_compute_target_https_proxy" "driplet_https_proxy" {
  name             = "driplet-https-proxy"
  url_map          = google_compute_url_map.driplet_url_map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.driplet_ssl_cert.self_link]
}

resource "google_compute_global_forwarding_rule" "driplet_https_forwarding_rule" {
  name                  = "driplet-https-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  target                = google_compute_target_https_proxy.driplet_https_proxy.self_link
  port_range            = "443"
  ip_address            = google_compute_global_address.new_loadbalancer_ip.address
}

resource "google_compute_region_network_endpoint_group" "driplet_service_neg" {
  name                  = "driplet-service-neg"
  region                = var.region
  network_endpoint_type = "SERVERLESS"
  cloud_run {
    service = google_cloud_run_v2_service.driplet_service.name
  }
}

resource "google_compute_backend_service" "driplet_driplet" {
  name                  = "driplet-cloud-run-backend"
  load_balancing_scheme = "EXTERNAL"
  protocol              = "HTTP"

  backend {
    group = google_compute_region_network_endpoint_group.driplet_service_neg.id
  }
}