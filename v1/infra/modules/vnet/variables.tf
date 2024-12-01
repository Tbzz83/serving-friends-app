variable "azurerm_resource_group" {
    description = "resource group object"
}

variable "source_address_prefix" {
    type = string
    sensitive = true
}

variable "tag" {
    type = string
}