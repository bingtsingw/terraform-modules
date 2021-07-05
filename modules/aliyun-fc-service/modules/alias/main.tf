resource "alicloud_fc_alias" "alias" {
  alias_name      = var.alias_name
  service_name    = var.service_name
  service_version = var.service_version

  lifecycle {
    ignore_changes = all
  }
}

resource "aliyun_fc_trigger" "trigger" {
  service   = var.service_name
  function  = var.function_name
  name      = "v-${var.alias_name}"
  type      = "http"
  qualifier = alicloud_fc_alias.alias.alias_name

  config = <<EOF
  {
    "authType": "anonymous",
    "methods": ["GET", "POST", "PUT", "DELETE", "HEAD", "PATCH"]
  }
  EOF

  lifecycle {
    ignore_changes = all
  }
}
