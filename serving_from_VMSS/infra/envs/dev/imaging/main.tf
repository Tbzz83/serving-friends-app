# Global variables
module "globals" {
  source = "../globals"
}

provider "azurerm" {
  subscription_id     = var.bnd_subscription_id
  storage_use_azuread = true
  features {}
}

data "azurerm_resource_group" "education" {
  name = "education"
}

data "azurerm_subnet" "imaging-subnet" {
  name                 = "imaging-subnet"
  virtual_network_name = "v1-vnet"
  resource_group_name  = data.azurerm_resource_group.education.name
}

module "vm_imaging" {
  source                 = "../../../modules/imaging"
  tag                    = module.globals.tag
  location               = module.globals.location
  my_personal_email      = var.my_personal_email
  azurerm_resource_group = data.azurerm_resource_group.education
  imaging-subnet         = data.azurerm_subnet.imaging-subnet
}
