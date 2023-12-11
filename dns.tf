data "google_dns_managed_zone" "default" {
  name = "doormat-accountid"
}

resource "google_dns_record_set" "default" {
  managed_zone = data.google_dns_managed_zone.default.name
  name         = "${local.vault_fqdn}."
  type         = "A"
  ttl          = 60

  rrdatas = [module.k8s.lb_ip_address]
}
