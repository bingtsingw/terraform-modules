variable "url" {
  type = string
}

variable "apdex_t" {
  type    = number
  default = 2.0
}

variable "period" {
  type    = number
  default = 3600
}

variable "disabled_locations" {
  type    = list(string)
  default = ["lan", "mia", "bhs", "rbx", "fra", "syd"]
}

variable "enabled" {
  type    = bool
  default = true
}

variable "published" {
  type    = bool
  default = false
}

variable "string_match" {
  type    = string
  default = ""
}
