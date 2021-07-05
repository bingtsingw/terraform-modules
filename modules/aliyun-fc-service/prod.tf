# role
module "role_prod" {
  source = "./modules/role"

  name          = local.name_dash_prod
  role_document = local.role_document
  policy_document = (var.policy_document_template_prod == "log"
    ? local.policy_document_template_log
    : var.policy_document_template_prod == "log_cr"
    ? local.policy_document_template_log_cr
    : var.policy_document_template_prod == "log_cr_vpc"
    ? local.policy_document_template_log_cr_vpc
    : var.policy_document_prod
  )
}

# log
module "log_prod" {
  source = "./modules/log"

  name             = local.name_dash_prod
  shard_count      = var.log_shard_count
  retention_period = var.log_retention_period
}

# vpc
resource "alicloud_security_group" "prod" {
  count = var.vpc_config ? 1 : 0

  name              = local.name_line_prod
  description       = local.name_line_prod
  vpc_id            = var.vpc_id
  resource_group_id = var.resource_group_id
}

# fc
resource "alicloud_fc_service" "prod" {
  name            = local.name_service_prod
  internet_access = var.fc_internet_access
  role            = module.role_prod.arn

  log_config {
    project  = module.log_prod.project.name
    logstore = module.log_prod.store.name
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config ? [1] : []

    content {
      vswitch_ids       = var.vpc_vswitch_ids
      security_group_id = alicloud_security_group.prod[0].id
    }
  }
}

resource "alicloud_fc_function" "prod" {
  service              = alicloud_fc_service.prod.name
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

resource "aliyun_fc_version" "prod" {
  service_name = alicloud_fc_service.prod.name

  depends_on = [
    alicloud_fc_function.prod
  ]
}

# alias
module "alias_production" {
  source = "./modules/alias"

  service_name    = alicloud_fc_service.prod.name
  function_name   = alicloud_fc_function.prod.name
  service_version = aliyun_fc_version.prod.id
  alias_name      = "production"
}

module "alias_preview" {
  source = "./modules/alias"

  service_name    = alicloud_fc_service.prod.name
  function_name   = alicloud_fc_function.prod.name
  service_version = aliyun_fc_version.prod.id
  alias_name      = "preview"
}
