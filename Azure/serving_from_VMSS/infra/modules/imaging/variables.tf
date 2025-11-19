variable "azurerm_resource_group" {
  description = "resource group object"
}

variable "imaging-subnet" {
  description = "frontend subnet"
}

variable "tag" {
  type = string
}

variable "location" {
  type = string
}

variable "my_personal_email" {
  type      = string
  sensitive = true
}