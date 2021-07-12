resource "alicloud_cr_repo" "repo" {
  namespace = var.namespace
  name      = var.name
  summary   = var.name
  repo_type = "PRIVATE"
}

module "ram-user-oss" {
  source = "github.com/bingtsingw/terraform-modules.git//modules/aliyun-ram-user-policy?ref=v0.11.0"

  name   = "cr-${var.name}"
  policy = <<EOF
  {
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "cr:PushRepository",
          "cr:PullRepository"
        ],
        "Resource": "acs:cr:${var.region}:*:repository/${var.namespace}/${var.name}"
      },
      {
        "Effect": "Allow",
        "Action": "cr:GetAuthorizationToken",
        "Resource": "*"
      }
    ],
    "Version": "1"
  }
  EOF
}
