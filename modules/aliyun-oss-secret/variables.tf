variable "account_id" {
  type = string
}

variable "ram_name" {
  type = string
}

variable "bucket" {
  type = string
}

variable "file_count" {
  type = number
}

variable "file_paths" {
  type = list(string)
}

variable "file_contents" {
  type = list(string)
}
