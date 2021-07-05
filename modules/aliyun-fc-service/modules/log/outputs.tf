output "project" {
  value = {
    name = alicloud_log_project.project.name
  }
}

output "store" {
  value = {
    name = alicloud_log_store.store.name
  }
}
