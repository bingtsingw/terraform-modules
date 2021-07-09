resource "alicloud_oss_bucket_object" "oss" {
  bucket  = var.bucket
  key     = var.key
  content = var.content
}

module "ram-user-oss" {
  source = "github.com/bingtsingw/terraform-modules.git//modules/aliyun-ram-user-policy?ref=v0.11.0"

  name   = var.ram_name
  policy = <<EOF
  {
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "oss:GetObject",
        "Resource": "acs:oss:*:${var.account_id}:${var.bucket}/${var.key}"
      }
    ],
    "Version": "1"
  }
  EOF
}
