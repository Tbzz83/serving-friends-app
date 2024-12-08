provider "azurerm" {
  subscription_id     = var.bnd_subscription_id
  storage_use_azuread = true
  features {}
}

data "azurerm_resource_group" "education" {
  name = "education"
}

resource "azurerm_container_registry" "edu_acr" {
  name                    = "eduacr"
  resource_group_name     = data.azurerm_resource_group.education.name
  location                = data.azurerm_resource_group.education.location
  sku                     = "Standard"
  admin_enabled           = true 
  zone_redundancy_enabled = false
}

