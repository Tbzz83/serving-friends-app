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

# Azure AD admin (me)
data "azurerm_client_config" "current" {
}

# subnet for the db
data "azurerm_subnet" "db-subnet" {
  name                 = "db-subnet"
  virtual_network_name = data.azurerm_virtual_network.app_vnet.name
  resource_group_name  = data.azurerm_resource_group.education.name
}

# App vnet
data "azurerm_virtual_network" "app_vnet" {
  name                = "v1-vnet"
  resource_group_name = data.azurerm_resource_group.education.name
}

module "azurerm_mysql_flexible_server" {
  source                 = "../../../modules/sql"
  name                   = "friendsapp-mysql-100329-${module.globals.tag}"
  azurerm_resource_group = data.azurerm_resource_group.education
  # 0.0.0.0 turns on allow all azure resources to access MySQL DB setting in Portal 
  # Allowed ips will be overwritten by 'allow_public_access' in prod so just leave
  allowed_ips = var.allowed_ips_list

  mysql_admin_name = "mysqladmin"
  mysql_admin_pw   = var.ai_dev_sql_pw
  tag              = module.globals.tag
  db_sku           = "B_Standard_B1s"
  db_subnet        = data.azurerm_subnet.db-subnet
  location         = module.globals.location
  app_vnet         = data.azurerm_virtual_network.app_vnet

  # Set false in prod
  allow_public_network_access = false
}
