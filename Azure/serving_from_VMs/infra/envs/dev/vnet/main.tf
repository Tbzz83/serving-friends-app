provider "azurerm" {
  subscription_id     = var.bnd_subscription_id
  storage_use_azuread = true
  features {}
}

data "azurerm_resource_group" "education" {
  name = "education"
}

module "azurerm_virtual_network" {
  source                 = "../../../modules/vnet"
  azurerm_resource_group = data.azurerm_resource_group.education
  source_address_prefix  = var.source_address_prefix_my_pc
  tag                    = "dev"
}

