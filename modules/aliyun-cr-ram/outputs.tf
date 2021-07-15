output "repo" {
  value = alicloud_cr_repo.repo
}

output "image" {
  value = local.image
}

output "user" {
  value = module.ram.user
}

output "ak" {
  value = alicloud_ram_access_key.ak.id
}

output "sk" {
  value = alicloud_ram_access_key.ak.secret
}
