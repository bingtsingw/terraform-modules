output "ak" {
  value = length(alicloud_ram_access_key.ak) > 0 ? alicloud_ram_access_key.ak[0].id : ""
}

output "sk" {
  value = length(alicloud_ram_access_key.ak) > 0 ? alicloud_ram_access_key.ak[0].secret : ""
}
