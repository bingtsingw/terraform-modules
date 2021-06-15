variable "name" {
  type = string
}

variable "internet_access" {
  type = bool
}

variable "policy_document" {
  type = string
}

variable "vpc_config" {
  type = bool
}

variable "vpc_id" {
  type    = string
  default = null
}

variable "vswitch_ids" {
  type    = list(string)
  default = null
}

variable "resource_group_id" {
  type    = string
  default = null
}
