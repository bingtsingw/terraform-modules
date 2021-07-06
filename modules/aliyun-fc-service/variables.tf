variable "name" {
  type = string
}

variable "resource_group_id" {
  type    = string
  default = null
}

variable "log_shard_count" {
  type    = number
  default = 1
}

variable "log_retention_period" {
  type    = number
  default = 3650
}

variable "policy_document_dev" {
  type    = string
  default = null
}

variable "policy_document_prod" {
  type    = string
  default = null
}

variable "policy_document_template_dev" {
  type    = string
  default = null
}

variable "policy_document_template_prod" {
  type    = string
  default = null
}

variable "vpc_config" {
  type = bool
}

variable "vpc_id" {
  type    = string
  default = null
}

variable "vpc_vswitch_ids" {
  type    = list(string)
  default = null
}

variable "fc_internet_access" {
  type = bool
}

variable "fc_memory_size" {
  type    = string
  default = "128"
}

variable "fc_runtime" {
  type    = string
  default = "custom-container"
}

variable "fc_handler" {
  type    = string
  default = "index.handler"
}

variable "fc_timeout" {
  type    = number
  default = 60
}

variable "fc_instance_concurrency" {
  type    = number
  default = 100
}

variable "fc_custom_container_image" {
  type = string
}
