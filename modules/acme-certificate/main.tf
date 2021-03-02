resource "tls_private_key" "account" {
  algorithm = "RSA"
}

resource "acme_registration" "account" {
  account_key_pem = tls_private_key.account.private_key_pem
  email_address   = var.email
}

resource "tls_private_key" "certificate" {
  algorithm = "RSA"
}

resource "tls_cert_request" "certificate" {
  depends_on = [acme_registration.account]


  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.certificate.private_key_pem
  dns_names       = var.dns_names

  subject {
    common_name = var.dns_names[0]
  }
}

resource "acme_certificate" "certificate" {
  account_key_pem         = acme_registration.account.account_key_pem
  certificate_request_pem = tls_cert_request.certificate.cert_request_pem
  min_days_remaining      = var.min_days_remaining
  recursive_nameservers   = var.recursive_nameservers != [] ? var.recursive_nameservers : null

  dynamic "dns_challenge" {
    for_each = [var.dns_challenge]
    content {
      config   = dns_challenge.value.config
      provider = dns_challenge.value.provider
    }
  }
}

resource "local_file" "cert" {
  sensitive_content = "${trimspace(acme_certificate.certificate.certificate_pem)}\n${acme_certificate.certificate.issuer_pem}"
  filename          = "certificate/${var.dns_names[0]}.cert"
  file_permission   = "0600"
}

resource "local_file" "key" {
  sensitive_content = tls_private_key.certificate.private_key_pem
  filename          = "certificate/${var.dns_names[0]}.key"
  file_permission   = "0600"
}
