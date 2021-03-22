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

## Reference

[nephosolutions/terraform-acme-certificate](https://github.com/nephosolutions/terraform-acme-certificate)
