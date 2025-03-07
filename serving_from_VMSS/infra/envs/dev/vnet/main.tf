# Global variables
module "globals" {
  source = "../globals"
}

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
  allowed_ips_list = var.allowed_ips_list
  location               = module.globals.location
  tag                    = "dev"
}

