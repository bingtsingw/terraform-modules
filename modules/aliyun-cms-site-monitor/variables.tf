variable "name" {
  type = string
}

variable "site" {
  type = string
}

variable "content" {
  type = string
}

variable "contact" {
  type = list(string)
}

variable "interval" {
  type = number
}

variable "silence_time" {
  type    = number
  default = 21600 # 沉默时间6小时
}

variable "times" {
  type    = number
  default = 3
}
