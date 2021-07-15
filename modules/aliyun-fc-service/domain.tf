locals {
  custom_domain = "${alicloud_dns_record.custom_domain.host_record}.${alicloud_dns_record.custom_domain.name}"
}

resource "alicloud_dns_record" "custom_domain" {
  name        = var.domain_name
  host_record = var.domain_record
  type        = "CNAME"
  value       = var.domain_cname
}

resource "alicloud_fc_custom_domain" "custom_domain" {
  domain_name = local.custom_domain
  protocol    = "HTTP,HTTPS"

  route_config {
    path          = "/api/v.${module.alias_production.trigger.qualifier}/*"
    service_name  = alicloud_fc_service.prod.name
    function_name = alicloud_fc_function.prod.name
    qualifier     = module.alias_production.trigger.qualifier
    methods       = ["GET", "POST", "PUT", "DELETE", "HEAD", "PATCH"]
  }

  route_config {
    path          = "/api/v.${module.alias_preview.trigger.qualifier}/*"
    service_name  = alicloud_fc_service.prod.name
    function_name = alicloud_fc_function.prod.name
    qualifier     = module.alias_preview.trigger.qualifier
    methods       = ["GET", "POST", "PUT", "DELETE", "HEAD", "PATCH"]
  }

  route_config {
    path          = "/api/v.${module.alias_development.trigger.qualifier}/*"
    service_name  = alicloud_fc_service.dev.name
    function_name = alicloud_fc_function.dev.name
    qualifier     = module.alias_development.trigger.qualifier
    methods       = ["GET", "POST", "PUT", "DELETE", "HEAD", "PATCH"]
  }

  cert_config {
    cert_name   = local.name_dash
    certificate = var.domain_cert
    private_key = var.domain_key
  }

  lifecycle {
    ignore_changes = [route_config]
  }
}
