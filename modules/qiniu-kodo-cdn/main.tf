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
