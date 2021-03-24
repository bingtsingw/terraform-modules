output "certificate_pem" {
  description = "The certificate in PEM format."
  value       = acme_certificate.certificate.certificate_pem
}

output "issuer_pem" {
  description = "The intermediate certificate of the issuer."
  value       = acme_certificate.certificate.issuer_pem
}

output "fullchain_pem" {
  description = "The certificate concatenated with the issuer."
  value       = "${trimspace(acme_certificate.certificate.certificate_pem)}\n${acme_certificate.certificate.issuer_pem}"
}

output "private_key_pem" {
  description = "The certificate's private key, in PEM format."
  value       = tls_private_key.certificate.private_key_pem
}
