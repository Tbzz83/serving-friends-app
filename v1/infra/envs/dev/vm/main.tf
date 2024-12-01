provider "azurerm" {
  subscription_id     = var.bnd_subscription_id
  storage_use_azuread = true
  features {}
}

data "azurerm_resource_group" "education" {
  name = "education"
}

data "azurerm_subnet" "frontend-subnet" {
    name = "frontend-subnet"
    virtual_network_name = "v1-vnet"
    resource_group_name = data.azurerm_resource_group.education.name
}

data "azurerm_subnet" "backend-subnet" {
    name = "backend-subnet"
    virtual_network_name = "v1-vnet"
    resource_group_name = data.azurerm_resource_group.education.name
}

#module "azurerm_virtual_machine" {
#    source = "../../../modules/vm"
#    frontend-subnet = data.azurerm_subnet.frontend-subnet
#    backend-subnet = data.azurerm_subnet.backend-subnet
#    tag = "dev"
#    azurerm_resource_group = data.azurerm_resource_group.education
#}

