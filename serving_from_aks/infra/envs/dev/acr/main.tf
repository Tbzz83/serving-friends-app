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

module "azurerm_container_registry" {
  source                 = "../../../modules/acr"
  name                   = "eduacr${module.globals.tag}"
  azurerm_resource_group = data.azurerm_resource_group.education
  location               = module.globals.location
  acr_sku                = "Standard"
  tag                    = module.globals.tag
}

