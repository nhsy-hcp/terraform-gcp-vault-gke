locals {
  lb_name = "lb-vault-${var.unique_id}"
}

resource "tls_private_key" "default" {
  count = var.create ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "vault" {
  count = var.create ? 1 : 0

  private_key_pem = tls_private_key.default[0].private_key_pem

  dns_names = var.dns_names

  subject {
    common_name  = var.domain
    organization = var.organization
  }

  validity_period_hours = 24 * 365

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "kubernetes_namespace_v1" "default" {
  count = var.create ? 1 : 0

  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret_v1" "tls" {
  count = var.create ? 1 : 0

  metadata {
    name      = var.tls_secret_name
    namespace = kubernetes_namespace_v1.default[0].metadata.0.name
  }
  data = {
    (var.tls_secret_crt) = tls_self_signed_cert.vault[0].cert_pem
    (var.tls_secret_key) = tls_self_signed_cert.vault[0].private_key_pem
  }
  type = "kubernetes.io/tls"
}

resource "kubernetes_secret_v1" "tls_ca" {
  count = var.create ? 1 : 0

  metadata {
    name      = var.tls_ca_secret_name
    namespace = kubernetes_namespace_v1.default[0].metadata.0.name
  }
  data = {
    (var.tls_ca_secret_crt) = tls_self_signed_cert.vault[0].cert_pem
  }
}

resource "google_compute_global_address" "default" {
  count = var.create ? 1 : 0
  name  = local.lb_name
}

resource "kubernetes_manifest" "hc_vault" {
  count = var.create ? 1 : 0
  manifest = yamldecode(templatefile("${path.module}/templates/vault-healthcheck.yaml",
    {
      name      = var.health_check_name
      namespace = kubernetes_namespace_v1.default[0].metadata.0.name
  }))
}

resource "helm_release" "vault" {
  count = var.create ? 1 : 0

  name       = "vault"
  repository = "helm.releases.hashicorp.com"
  chart      = "hashicorp/vault"
  version    = "0.27.0"

  namespace = kubernetes_namespace_v1.default[0].metadata.0.name
  values = [
    "${templatefile("${path.module}/templates/vault-values.yaml",
      {
        lb_ip_address_name = google_compute_global_address.default[0].name
        vault_healthcheck  = var.health_check_name
        fqdn               = var.fqdn
    })}"
  ]

  wait = true

  depends_on = [
    kubernetes_manifest.hc_vault,
  ]
}