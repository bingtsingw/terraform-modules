
locals {
  name_dash    = replace(var.name, "_", "-")
  name_line    = replace(var.name, "-", "_")
  name_service = replace(local.name_dash, "fc-", "")
}

# role
resource "alicloud_ram_role" "default" {
  name     = local.name_dash
  document = <<EOF
  {
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": [
            "fc.aliyuncs.com"
          ]
        }
      }
    ],
    "Version": "1"
  }
  EOF
}

resource "alicloud_ram_policy" "default" {
  policy_name     = local.name_dash
  policy_document = var.policy_document
  description     = "policy for ram role '${local.name_dash}'"
}

resource "alicloud_ram_role_policy_attachment" "default" {
  role_name   = alicloud_ram_role.default.name
  policy_name = alicloud_ram_policy.default.name
  policy_type = alicloud_ram_policy.default.type
}

# vpc
resource "alicloud_security_group" "default" {
  count = var.vpc_config ? 1: 0

  name              = local.name_line
  description       = local.name_line
  vpc_id            = var.vpc_id
  resource_group_id = var.resource_group_id
}

# log
resource "alicloud_log_project" "default" {
  name        = local.name_dash
  description = local.name_dash
}

resource "alicloud_log_store" "default" {
  name                  = local.name_dash
  project               = alicloud_log_project.default.name
  auto_split            = true
  max_split_shard_count = 60
}

# fc
resource "alicloud_fc_service" "default" {
  name            = local.name_service
  internet_access = var.internet_access
  role            = alicloud_ram_role.default.arn

  log_config {
    project  = alicloud_log_project.default.name
    logstore = alicloud_log_store.default.name
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config ? [1]: []

    content {
    vswitch_ids       = var.vswitch_ids
    security_group_id = alicloud_security_group.default[0].id
    }
  }
}
