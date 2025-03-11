resource "azurerm_container_registry" "edu_acr" {
  name                    = var.name
  resource_group_name     = var.azurerm_resource_group.name
  location                = var.location
  sku                     = var.acr_sku
  admin_enabled           = true
  zone_redundancy_enabled = false
  tags = {
    environment = var.tag
  }
}
