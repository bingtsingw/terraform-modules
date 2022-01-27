resource "aliyun_dcdn_domain" "dcdn" {
  domain_name       = "${var.dcdn_domain_record}.${var.dcdn_domain_name}"
  scope             = var.dcdn_scope
  resource_group_id = var.resource_group_id

  sources {
    type    = "domain"
    content = local.custom_domain
    port    = 443
  }
}

resource "aliyun_dcdn_domain_cert" "dcdn" {
  domain_name = aliyun_dcdn_domain.dcdn.domain_name
  cert_name   = local.name_dash
  ssl_pub     = var.domain_cert
  ssl_pri     = var.domain_key
}

resource "aliyun_dcdn_domain_config" "https_force" {
  domain_name   = aliyun_dcdn_domain.dcdn.domain_name
  function_name = "https_force"

  function_args {
    arg_name  = "enable"
    arg_value = "on"
  }
}

resource "aliyun_dcdn_domain_config" "https_option" {
  domain_name   = aliyun_dcdn_domain.dcdn.domain_name
  function_name = "https_option"

  function_args {
    arg_name  = "http2"
    arg_value = "on"
  }

  function_args {
    arg_name  = "ocsp_stapling"
    arg_value = "on"
  }
}

resource "aliyun_dcdn_domain_config" "https_tls_version" {
  domain_name   = aliyun_dcdn_domain.dcdn.domain_name
  function_name = "https_tls_version"

  function_args {
    arg_name  = "tls10"
    arg_value = "on"
  }

  function_args {
    arg_name  = "tls11"
    arg_value = "on"
  }

  function_args {
    arg_name  = "tls12"
    arg_value = "on"
  }

  function_args {
    arg_name  = "tls13"
    arg_value = "on"
  }
}

resource "aliyun_dcdn_domain_config" "forward_scheme" {
  domain_name   = aliyun_dcdn_domain.dcdn.domain_name
  function_name = "forward_scheme"

  function_args {
    arg_name  = "enable"
    arg_value = "on"
  }

  function_args {
    arg_name  = "scheme_origin"
    arg_value = "https"
  }

  function_args {
    arg_name  = "scheme_origin_port"
    arg_value = "443"
  }
}

resource "aliyun_dcdn_domain_config" "hsts" {
  domain_name   = aliyun_dcdn_domain.dcdn.domain_name
  function_name = "HSTS"

  function_args {
    arg_name  = "enabled"
    arg_value = "on"
  }

  function_args {
    arg_name  = "https_hsts_max_age"
    arg_value = "5184000"
  }
}

resource "aliyun_dcdn_domain_config" "set_req_host_header" {
  domain_name   = aliyun_dcdn_domain.dcdn.domain_name
  function_name = "set_req_host_header"

  function_args {
    arg_name  = "domain_name"
    arg_value = local.custom_domain
  }
}

resource "alicloud_dns_record" "dcdn" {
  name        = var.dcdn_domain_name
  host_record = var.dcdn_domain_record
  type        = "CNAME"
  value       = aliyun_dcdn_domain.dcdn.cname
}

module "health-check" {
  count = var.dcdn_health_check ? 1 : 0

  source = "github.com/bingtsingw/terraform-modules.git//modules/updown-check?ref=v0.17.0"

  url    = "https://${alicloud_dns_record.dcdn.host_record}.${alicloud_dns_record.dcdn.name}/api/v.${module.alias_production.trigger.qualifier}/health"
  period = 300
}
