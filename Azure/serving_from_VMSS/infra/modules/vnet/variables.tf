variable "azurerm_resource_group" {
  description = "resource group object"
}

variable "allowed_ips_list" {
  type      = list(string)
  sensitive = true
}

variable "tag" {
  type = string
}

variable "location" {
  type = string
}