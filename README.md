# bingtsingw-terraform-modules

Personal using modules

## Usage

### qiniu-kodo-cdn

usage:

```hcl
module "MODULE" {
  source = "github.com/bingtsingw/terraform-modules.git//modules/qiniu-kodo-cdn?ref=vx.x.x"

  domain   = var.domain
  platform = var.platform
  bucket   = var.bucket
  cert     = var.cert_id
}
```

import:

```shell
terraform import module.$MODULE.qiniu_cdn_domain.domain $DOMAIN
```

### aliyun-ram-user-policy

usage:

```hcl
module "MODULE" {
  source = "github.com/bingtsingw/terraform-modules.git//modules/aliyun-ram-user-policy?ref=vx.x.x"

  name   = "api-academix"
  policy = <<EOF
  {
    "Statement": [
      {
        "Effect": "Allow",
        "Action": ["ram:*"],
        "Resource": ["*"]
      }
    ],
    "Version": "1"
  }
  EOF
}
```

import:

[attachment id format](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ram_user_policy_attachment#id)

```shell
terraform import module.$MODULE.alicloud_ram_user.user $RAM_USER_ID
terraform import module.$MODULE.alicloud_ram_policy.policy $POLICY_NAME
terraform import module.$MODULE.alicloud_ram_user_policy_attachment.attach $ATTACHMENT_ID
```

### updown-check

usage:

```hcl
module "MODULE" {
  source = "github.com/bingtsingw/terraform-modules.git//modules/updown-check?ref=vx.x.x"

  url = "https://www.google.com"
}
```

## Reference

[nephosolutions/terraform-acme-certificate](https://github.com/nephosolutions/terraform-acme-certificate)
