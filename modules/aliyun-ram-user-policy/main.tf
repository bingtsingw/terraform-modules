resource "alicloud_ram_user" "user" {
  name         = var.name
  display_name = var.name
}

resource "alicloud_ram_policy" "policy" {
  policy_name     = var.name
  description     = "policy for ram user '${var.name}'"
  policy_document = var.policy
}

resource "alicloud_ram_user_policy_attachment" "attach" {
  user_name   = alicloud_ram_user.user.name
  policy_name = alicloud_ram_policy.policy.name
  policy_type = alicloud_ram_policy.policy.type
}
