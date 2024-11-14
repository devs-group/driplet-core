output "driplet_service_url" {
  value = google_cloud_run_v2_service.driplet_service.uri
}

output "loadbalancer_ip" {
  value = google_compute_global_address.new_loadbalancer_ip.address
}