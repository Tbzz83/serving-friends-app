variable "azurerm_resource_group" {
  type = any
}

variable "tag" {
  type = string
}

variable "vm_sku" {
  type = string
}

variable "api_app_subnet" {
  type = any
}

variable "ui_app_subnet" {
  type = any
}

variable "source_address_prefix_my_pc" {
  type      = string
  sensitive = true
}

variable "maximum_burst" {
  type = number
}

variable "static_app_sku_size" {
  type = string
}

variable "static_app_sku_tier" {
  type = string
}

variable "app_vnet" {
  description = "virtual network app deployed in"
  type = any
}

variable "api_public_access" {
  type = bool
}

variable "ui_public_access" {
  type = bool
}

variable "location" {
  type = string
}

variable "frontend_app_name" {
  type = string
}

variable "backend_app_name" {
  type = string
}