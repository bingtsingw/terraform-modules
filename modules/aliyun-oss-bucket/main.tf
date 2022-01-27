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

  dynamic "cors_rule" {
    for_each = var.cors_rule ? [1] : []

    content {
      allowed_headers = ["*"]
      allowed_methods = ["GET", "POST"]
      allowed_origins = ["*"]
      expose_headers  = []
      max_age_seconds = 0
    }
  }
}
