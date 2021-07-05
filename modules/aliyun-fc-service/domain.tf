resource "alicloud_fc_custom_domain" "domain" {
  domain_name = var.fc_domain
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
    path          = "/api/v.${module.alias_develop.trigger.qualifier}/*"
    service_name  = alicloud_fc_service.prod.name
    function_name = alicloud_fc_function.prod.name
    qualifier     = module.alias_develop.trigger.qualifier
    methods       = ["GET", "POST", "PUT", "DELETE", "HEAD", "PATCH"]
  }

  cert_config {
    cert_name   = local.name_line
    certificate = var.cert
    private_key = var.cert_key
  }
}
