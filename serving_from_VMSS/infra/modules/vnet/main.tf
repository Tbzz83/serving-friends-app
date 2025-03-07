# VNet
resource "azurerm_virtual_network" "v1-vnet" {
  name                = "v1-vnet"
  resource_group_name = var.azurerm_resource_group.name
  location            = var.location
  address_space       = ["10.0.0.0/16"]
  tags = {
    environment = var.tag
  }
}

# Subnets. One for frontend, and one for backend, one for the db
resource "azurerm_subnet" "frontend-subnet" {
  name                 = "frontend-subnet"
  resource_group_name  = var.azurerm_resource_group.name
  virtual_network_name = azurerm_virtual_network.v1-vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "backend-subnet" {
  name                 = "backend-subnet"
  resource_group_name  = var.azurerm_resource_group.name
  virtual_network_name = azurerm_virtual_network.v1-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "db-subnet" {
  name                 = "db-subnet"
  resource_group_name  = var.azurerm_resource_group.name
  virtual_network_name = azurerm_virtual_network.v1-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "imaging-subnet" {
  name                 = "imaging-subnet"
  resource_group_name  = var.azurerm_resource_group.name
  virtual_network_name = azurerm_virtual_network.v1-vnet.name
  address_prefixes     = ["10.0.3.0/24"]

}

# NSG
resource "azurerm_network_security_group" "app-nsg" {
  name                = "app-nsg"
  location            = var.location
  resource_group_name = var.azurerm_resource_group.name
  tags = {
    environment = var.tag
  }
}

# Inbound security rule
resource "azurerm_network_security_rule" "nsgrulessh" {
  name                        = "nsgrulessh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefixes     = var.allowed_ips_list
  destination_address_prefix  = "*"
  resource_group_name         = var.azurerm_resource_group.name
  network_security_group_name = azurerm_network_security_group.app-nsg.name
}

#resource "azurerm_network_security_rule" "nsgrulehttp" {
#  name                        = "nsgrulehttp"
#  priority                    = 110
#  direction                   = "Inbound"
#  access                      = "Allow"
#  protocol                    = "Tcp"
#  source_port_range           = "*"
#  destination_port_range      = "80"
#  source_address_prefixes     = var.allowed_ips_list
#  destination_address_prefix  = "*"
#  resource_group_name         = var.azurerm_resource_group.name
#  network_security_group_name = azurerm_network_security_group.app-nsg.name
#}

locals {
  subnets = {
    "frontend-subnet" = azurerm_subnet.frontend-subnet
    "backend-subnet"  = azurerm_subnet.backend-subnet
    "db-subnet"       = azurerm_subnet.db-subnet
    "imaging-subnet"  = azurerm_subnet.imaging-subnet
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg-association" {
  for_each                  = local.subnets
  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.app-nsg.id
}


