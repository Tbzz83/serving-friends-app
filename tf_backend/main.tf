## ---- MANAGES tfstate FOR STORING TFSTATE ----#
provider "azurerm" {
  subscription_id     = var.bnd_subscription_id
  storage_use_azuread = true
  features {}
}

data "azurerm_resource_group" "education" {
  name = "education"
}

resource "azurerm_storage_account" "tfstate_store" {
  name                              = "tfstatestore244938321"
  resource_group_name               = data.azurerm_resource_group.education.name
  location                          = data.azurerm_resource_group.education.location
  account_tier                      = "Standard"
  account_replication_type          = "LRS"
  https_traffic_only_enabled        = "true"
  shared_access_key_enabled         = "false"
  default_to_oauth_authentication   = "true"
  infrastructure_encryption_enabled = "true"

  tags = {
    environment = var.tag
  }
}

resource "azurerm_storage_container" "tfstate_container" {
  name                  = "tfstatecontainer"
  storage_account_id  = azurerm_storage_account.tfstate_store.id
  container_access_type = "private"
}



