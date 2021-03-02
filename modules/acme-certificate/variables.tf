variable "email" {
  type = string
}

variable "dns_names" {
  type = list(string)
}

variable "dns_challenge" {
  type = object({
    provider = string
    config   = map(string)
  })
}

variable "min_days_remaining" {
  type    = number
  default = 30
}

variable "recursive_nameservers" {
  type    = list(string)
  default = []
}
