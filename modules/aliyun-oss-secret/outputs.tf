output "user" {
  value = module.ram-user-oss.user
}

output "ak" {
  value = alicloud_ram_access_key.ak.id
}

output "sk" {
  value = alicloud_ram_access_key.ak.secret
}
