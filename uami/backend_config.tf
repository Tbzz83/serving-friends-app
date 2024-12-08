terraform {
  backend "azurerm" {
    resource_group_name  = "education"
    storage_account_name = "tfstatestore244938321"
    container_name       = "tfstatecontainer"
    key                  = "uami/terraform.tfstate"
    use_azuread_auth     = true
  }
}