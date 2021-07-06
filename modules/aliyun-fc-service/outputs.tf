output "production" {
  value = {
    qualifier = module.alias_production.trigger.qualifier
    service   = alicloud_fc_service.prod.name
    function  = alicloud_fc_function.prod.name
  }
}

output "preview" {
  value = {
    qualifier = module.alias_preview.trigger.qualifier
    service   = alicloud_fc_service.prod.name
    function  = alicloud_fc_function.prod.name
  }
}

output "develop" {
  value = {
    qualifier = module.alias_develop.trigger.qualifier
    service   = alicloud_fc_service.dev.name
    function  = alicloud_fc_function.dev.name
  }
}
