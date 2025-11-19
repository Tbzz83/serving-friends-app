variable "azurerm_resource_group" {
  type = any
}

variable "tag" {
  type = string
}

variable "location" {
  type = string
}

variable "allowed_ips" {
  type      = list(string)
  sensitive = true
}

