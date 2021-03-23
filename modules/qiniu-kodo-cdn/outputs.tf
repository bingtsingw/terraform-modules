output "cname" {
  description = "cdn cname"
  value       = qiniu_cdn_domain.domain.cname
}

output "domain" {
  description = "domain"
  value       = var.domain
}
