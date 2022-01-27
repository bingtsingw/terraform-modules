variable "bucket" {
  type = string
}

variable "acl" {
  type = string
}

variable "log" {
  type = string
}

variable "cors_rule" {
  type    = bool
  default = false
}
