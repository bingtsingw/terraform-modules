locals {
  resources = formatlist("\"acs:oss:*:%s:%s/%s\"", var.account_id, var.bucket, var.file_paths)
}
resource "alicloud_oss_bucket_object" "oss" {
  count = var.file_count

  bucket  = var.bucket
  key     = var.file_paths[count.index]
  content = var.file_contents[count.index]
}

module "ram-user-oss" {
  source = "../aliyun-ram-user-policy"

  name   = var.ram_name
  policy = <<EOF
  {
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "oss:GetObject",
        "Resource": [${join(", ", local.resources)}]
      }
    ],
    "Version": "1"
  }
  EOF
}

resource "alicloud_ram_access_key" "ak" {
  user_name = module.ram-user-oss.user.name
}
