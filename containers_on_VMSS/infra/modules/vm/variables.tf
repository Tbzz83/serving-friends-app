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