resource "qiniu_cdn_domain" "domain" {
  type      = "normal"
  protocol  = "https"
  name      = var.domain
  platform  = var.platform
  geo_cover = var.geo

  source {
    type         = "qiniuBucket"
    qiniu_bucket = var.bucket
  }

  https {
    cert_id = var.cert
    force   = true
    http2   = true
  }

  cache {
    ignore_param = false

    controls {
      time     = 1
      timeunit = 6
      type     = "all"
      rule     = "*"
    }
  }
}

resource "alicloud_dns_record" "dns" {
  name        = "${element(split(".", var.domain), 1)}.${element(split(".", var.domain), 2)}"
  host_record = element(split(".", var.domain), 0)
  type        = "CNAME"
  value       = qiniu_cdn_domain.domain.cname
}

module "health-check" {
  source = "github.com/bingtsingw/terraform-modules.git//modules/updown-check?ref=v0.17.0"

  url = "${qiniu_cdn_domain.domain.protocol}://${alicloud_dns_record.dns.host_record}.${alicloud_dns_record.dns.name}/${tolist(qiniu_cdn_domain.domain.source)[0].test_url_path}"
}
