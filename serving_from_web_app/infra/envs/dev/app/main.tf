# Global variables
module "globals" {
  source = "../globals"
}

provider "azurerm" {
  subscription_id = var.bnd_subscription_id
  # Configuration options
  features {

  }
}

# Rg data 
data "azurerm_resource_group" "education" {
  name = "education"
}

# subnet for api app VNet integration
data "azurerm_subnet" "api-app-subnet" {
  name                 = "api-app-subnet-${module.globals.tag}"
  virtual_network_name = "app-vnet-${module.globals.tag}"
  resource_group_name  = data.azurerm_resource_group.education.name
}

# subnet for the ui app
data "azurerm_subnet" "ui-app-subnet" {
  name                 = "ui-app-subnet-${module.globals.tag}"
  virtual_network_name = "app-vnet-${module.globals.tag}"
  resource_group_name  = data.azurerm_resource_group.education.name
}

data "azurerm_virtual_network" "app_vnet" {
  name                = "app-vnet-${module.globals.tag}"
  resource_group_name = data.azurerm_resource_group.education.name
}

# Azure AD admin (me)
data "azurerm_client_config" "current" {
}

module "app" {
  source                 = "../../../modules/app"
  frontend_app_name = "friendsapp-frontend-${module.globals.tag}"
  backend_app_name = "friendsapp-backend-${module.globals.tag}"
  azurerm_resource_group = data.azurerm_resource_group.education
  tag                    = module.globals.tag

  # Have to specify location as App service plan quotas for the region are iffy
  location = module.globals.location
  # VM sku for flask API app
  vm_sku         = "P0v3"
  api_app_subnet = data.azurerm_subnet.api-app-subnet
  ui_app_subnet  = data.azurerm_subnet.ui-app-subnet
  # Allow my IP to connect through the firewall to backend
  source_address_prefix_my_pc = "${var.source_address_prefix_my_pc}/32"

  # Set false in prod
  api_public_access = true

  # Can leave as true in prod
  ui_public_access = true

  # Number of VM instances the web apps can scale out to
  maximum_burst = 2

  static_app_sku_size = "Standard"
  static_app_sku_tier = "Standard"

  app_vnet = data.azurerm_virtual_network.app_vnet
}

