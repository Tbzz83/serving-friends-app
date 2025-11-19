variable "azurerm_resource_group" {
  description = "resource group object"
}

variable "frontend-subnet" {
  description = "frontend subnet"
}

variable "backend-subnet" {
  description = "backend subnet"
}

variable "user_assigned_identity" {
  description = "uami for acr pull for VMs"
}

variable "tag" {
  type = string
}