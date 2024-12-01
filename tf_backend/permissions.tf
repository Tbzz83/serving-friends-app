# ---- LOADING USERS ---- #
# Loading myself in as a data source
data "azuread_client_config" "current" {}

# ---- PERMISSIONS FOR USERS (owners) ---- #
# Subscription data source

data "azurerm_role_definition" "storage_account_contributor" {
  name = "Storage Account Contributor"
}

data "azurerm_storage_account" "tfstate_store" {
  name                = "tfstatestorebio"
  resource_group_name = "tfstate_rg"
}

#resource "azurerm_role_assignment" "storage_account_contributor" {
#  scope                = data.azurerm_storage_account.tfstate_store.id
#  role_definition_name = "Storage Account Contributor"
#  principal_id         = data.azuread_client_config.current.object_id
#}

resource "azurerm_role_assignment" "storage_blob_data_contributor" {
  scope                = data.azurerm_storage_account.tfstate_store.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azuread_client_config.current.object_id
}