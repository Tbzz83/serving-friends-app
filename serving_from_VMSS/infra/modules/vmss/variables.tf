variable "azurerm_resource_group" {
  description = "resource group object"
}

variable "frontend-subnet" {
  description = "frontend subnet"
  type = any
}

variable "backend-subnet" {
  description = "backend subnet"
  type = any
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

variable "frontend-image" {
  type = any
}

variable "backend-image" {
  type = any
}

variable "app-nsg" {
  type = any
}