resource "alicloud_oss_bucket" "bucket" {
  bucket        = var.bucket
  storage_class = "Standard"
  acl           = var.acl

  server_side_encryption_rule {
    sse_algorithm = "AES256"
  }

  logging {
    target_bucket = var.log
    target_prefix = "oss-access/${var.bucket}/"
  }

  transfer_acceleration {
    enabled = false
  }
}
