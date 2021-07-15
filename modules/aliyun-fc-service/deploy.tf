# - 更新函数 (dev, prod)
# - 发布版本 (dev, prod)
# - 更新别名 (dev, prod)
# - 添加触发器 (dev)
# - 添加路由 (dev)
module "ram-deploy" {
  source = "github.com/bingtsingw/terraform-modules.git//modules/aliyun-ram-user-policy?ref=v0.17.0"

  name   = "${local.name_dash}-deploy"
  policy = <<EOF
  {
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "fc:UpdateFunction"
        ],
        "Resource": [
          "acs:fc:*:*:services/${local.name_service_dev}/functions/${local.name_function}",
          "acs:fc:*:*:services/${local.name_service_prod}/functions/${local.name_function}"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "fc:PublishServiceVersion"
        ],
        "Resource": [
          "acs:fc:*:*:services/${local.name_service_dev}/versions",
          "acs:fc:*:*:services/${local.name_service_prod}/versions"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "fc:UpdateAlias"
        ],
        "Resource": [
          "acs:fc:*:*:services/${local.name_service_dev}/aliases/*",
          "acs:fc:*:*:services/${local.name_service_prod}/aliases/*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "fc:CreateTrigger"
        ],
        "Resource": "acs:fc:*:*:services/${local.name_service_dev}/functions/${local.name_function}/triggers/*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "fc:GetCustomDomain",
          "fc:UpdateCustomDomain"
        ],
        "Resource": "acs:fc:*:*:custom-domains/${local.custom_domain}"
      }
    ],
    "Version": "1"
  }
  EOF
}

resource "alicloud_ram_access_key" "ak" {
  user_name = module.ram-deploy.user.name
}
