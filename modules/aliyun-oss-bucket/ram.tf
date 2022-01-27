module "aliyun-oss-bucket-ram" {
  count  = var.ram ? 1 : 0
  source = "github.com/bingtsingw/terraform-modules.git//modules/aliyun-ram-user-policy?ref=v0.20.0"

  name   = "oss-${var.bucket}-ram"
  policy = <<EOF
  {
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "oss:*",
        "Resource": [
          "acs:oss:*:*:${var.bucket}",
          "acs:oss:*:*:${var.bucket}/*"
        ]
      }
    ],
    "Version": "1"
  }
  EOF
}

resource "alicloud_ram_access_key" "ak" {
  count     = var.ram ? 1 : 0
  user_name = module.aliyun-oss-bucket-ram[0].user.name
}
