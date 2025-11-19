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


module "vnet" {
  source                 = "../../../modules/vnet"
  azurerm_resource_group = data.azurerm_resource_group.education
  tag                    = module.globals.tag

  location    = module.globals.location
  allowed_ips = var.allowed_ips_list
}
