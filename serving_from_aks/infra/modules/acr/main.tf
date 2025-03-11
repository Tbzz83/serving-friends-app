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
#
#resource "azurerm_container_registry_scope_map" "acrscope" {
#  name                    = "acrscope-${var.tag}"
#  container_registry_name = azurerm_container_registry.edu_acr.name
#  resource_group_name     = var.azurerm_resource_group.name
#  actions = [
#    "repositories/repo1/content/read"
#  ]
#}
#
#resource "azurerm_container_registry_token" "acrtokenread" {
#  name                    = "acrtokenread"
#  container_registry_name = azurerm_container_registry.edu_acr.name
#  resource_group_name     = var.azurerm_resource_group.name
#  scope_map_id            = azurerm_container_registry_scope_map.acrscope.id
#}