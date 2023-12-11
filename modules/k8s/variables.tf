variable "create" {
  type    = bool
  default = true
}

variable "dns_names" {
  type = list(string)
  default = [
    "*.vault-internal",
  ]
}

variable "domain" {
  type    = string
  default = "vault-internal"
}

variable "namespace" {
  type    = string
  default = "vault"
}

variable "tls_secret_name" {
  type    = string
  default = "tls"
}

variable "tls_secret_crt" {
  type    = string
  default = "tls.crt"
}

variable "tls_secret_key" {
  type    = string
  default = "tls.key"
}

variable "tls_ca_secret_name" {
  type    = string
  default = "tls-ca"
}

variable "tls_ca_secret_crt" {
  type    = string
  default = "ca.crt"
}

variable "organization" {
  type    = string
  default = "ACME"
}

variable "vault_license" {
  type    = string
  default = null
}

variable "vault_version" {
  type    = string
  default = "1.15.4"
}

variable "unique_id" {
  type = string
}

variable "health_check_name" {
  type    = string
  default = "hc-vault"
}

variable "fqdn" {
  type = string
}