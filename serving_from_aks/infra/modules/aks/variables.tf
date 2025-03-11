variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "azurerm_resource_group" {
  type = any
}

variable "tag" {
    type = string
}

variable "vm_size" {
  type = string
}