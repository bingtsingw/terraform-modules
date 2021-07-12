# role
module "role_dev" {
  source = "./modules/role"

  name          = local.name_dash_dev
  role_document = local.role_document
  policy_document = (var.policy_document_template_dev == "log"
    ? local.policy_document_template_log
    : var.policy_document_template_dev == "log_cr"
    ? local.policy_document_template_log_cr
    : var.policy_document_template_dev == "log_cr_vpc"
    ? local.policy_document_template_log_cr_vpc
    : var.policy_document_dev
  )
}

# log
module "log_dev" {
  source = "./modules/log"

  name             = local.name_dash_dev
  shard_count      = var.log_shard_count
  retention_period = var.log_retention_period
}

# fc
resource "alicloud_fc_service" "dev" {
  name            = local.name_service_dev
  internet_access = true
  role            = module.role_dev.arn

  log_config {
    project  = module.log_dev.project.name
    logstore = module.log_dev.store.name
  }
}

resource "alicloud_fc_function" "dev" {
  service              = alicloud_fc_service.dev.name
  name                 = local.name_function
  memory_size          = var.fc_memory_size
  runtime              = var.fc_runtime
  handler              = var.fc_handler
  timeout              = var.fc_timeout
  instance_concurrency = var.fc_instance_concurrency

  custom_container_config {
    image = var.fc_custom_container_image
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "aliyun_fc_version" "dev" {
  service_name = alicloud_fc_service.dev.name

  depends_on = [
    alicloud_fc_function.dev
  ]
}

# alias
module "alias_development" {
  source = "./modules/alias"

  service_name    = alicloud_fc_service.dev.name
  function_name   = alicloud_fc_function.dev.name
  service_version = aliyun_fc_version.dev.id
  alias_name      = "development"
}
