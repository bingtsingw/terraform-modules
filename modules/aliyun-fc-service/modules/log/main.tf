resource "alicloud_log_project" "project" {
  name        = var.name
  description = var.name
}

resource "alicloud_log_store" "store" {
  name                  = var.name
  project               = alicloud_log_project.project.name
  shard_count           = var.shard_count
  auto_split            = true
  max_split_shard_count = 60
  retention_period      = var.retention_period
}

resource "alicloud_log_store_index" "index" {
  project  = alicloud_log_project.project.name
  logstore = alicloud_log_store.store.name
  full_text {
    case_sensitive = false
    token          = ""
  }
}
