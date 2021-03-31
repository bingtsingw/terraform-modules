resource "tencentcloud_cam_user" "user" {
  name          = var.name
  remark        = var.name
  console_login = false
  use_api       = true
}

resource "tencentcloud_cam_policy" "policy" {
  name        = var.name
  description = "policy for ram user (${var.name})"
  document    = var.policy
}

resource "tencentcloud_cam_user_policy_attachment" "attach" {
  user_id   = tencentcloud_cam_user.user.id
  policy_id = tencentcloud_cam_policy.policy.id
}
