provider "azurerm" {
  subscription_id     = var.bnd_subscription_id
  storage_use_azuread = true
  features {}
}

# rg data
data "azurerm_resource_group" "education" {
  name = "education"
}

# User-assigned managed identity
resource "azurerm_user_assigned_identity" "vm_uami_acr" {
  location = data.azurerm_resource_group.education.location
  name = "vm_uami_acr"
  resource_group_name = data.azurerm_resource_group.education.name
}

# RBAC for UA MI access to pull container images from acr
# Role definitions

data "azurerm_subscription" "current" {}

data "azurerm_role_definition" "acr_pull" {
  name = "AcrPull"
}

resource "azurerm_role_assignment" "acr_pull" {
  scope              = data.azurerm_resource_group.education.id
  role_definition_id = "${data.azurerm_subscription.current.id}${data.azurerm_role_definition.acr_pull.id}"
  principal_id       = azurerm_user_assigned_identity.vm_uami_acr.principal_id
}
