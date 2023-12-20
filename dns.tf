data "google_dns_managed_zone" "default" {
  name = var.dns_managed_zone_name
}

resource "google_dns_record_set" "default" {
  count = var.create_k8s ? 1 : 0

  managed_zone = data.google_dns_managed_zone.default.name
  name         = "${var.vault_fqdn}."
  type         = "A"
  ttl          = 60

  rrdatas = [module.k8s.lb_ip_address]
}
