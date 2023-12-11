output "lb_ip_address" {
  value = try(google_compute_global_address.default[0].address, null)
}
