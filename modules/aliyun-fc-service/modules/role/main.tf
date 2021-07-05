resource "alicloud_ram_role" "role" {
  name     = var.name
  document = var.role_document
}

resource "alicloud_ram_policy" "policy" {
  policy_name     = var.name
  policy_document = var.policy_document
  description     = "policy for ram role '${var.name}'"
}

resource "alicloud_ram_role_policy_attachment" "attach" {
  role_name   = alicloud_ram_role.role.name
  policy_name = alicloud_ram_policy.policy.name
  policy_type = alicloud_ram_policy.policy.type
}
