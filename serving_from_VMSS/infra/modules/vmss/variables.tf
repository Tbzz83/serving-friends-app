variable "azurerm_resource_group" {
  description = "resource group object"
}

variable "frontend-subnet" {
  description = "frontend subnet"
}

variable "backend-subnet" {
  description = "backend subnet"
}

variable "tag" {
  type = string
}

variable "vmss_sku" {
  type = string
}

variable "location" {
  type = string
}

variable "my_personal_email" {
  type      = string
  sensitive = true
}