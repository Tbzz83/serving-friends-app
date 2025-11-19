resource "azurerm_virtual_network" "app-vnet" {
  name                = "app-vnet-${var.tag}"
  location            = var.location
  resource_group_name = var.azurerm_resource_group.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = var.tag
  }
}

# Subnet for api
resource "azurerm_subnet" "api-app-subnet" {
  name                 = "api-app-subnet-${var.tag}"
  resource_group_name  = var.azurerm_resource_group.name
  virtual_network_name = azurerm_virtual_network.app-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  private_link_service_network_policies_enabled = true

  # Delegation is necessary for VNet integration. Not allowed if using Private link
  delegation {
    name = "Server Farms delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}

# Subnet for frontend
resource "azurerm_subnet" "ui-app-subnet" {
  name                 = "ui-app-subnet-${var.tag}"
  resource_group_name  = var.azurerm_resource_group.name
  virtual_network_name = azurerm_virtual_network.app-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
  private_link_service_network_policies_enabled = true

  # Delegation is necessary for VNet integration. Not allowed if using Private link
  delegation {
    name = "Server Farms delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}

# Subnet for dev-vm
# subnet for a vm to test things if needed during development
resource "azurerm_subnet" "dev-vm-subnet" {
  name                 = "dev-vm-subnet-${var.tag}"
  resource_group_name  = var.azurerm_resource_group.name
  virtual_network_name = azurerm_virtual_network.app-vnet.name
  address_prefixes     = ["10.0.4.0/24"]
}

# Subnet for MySQL DB
resource "azurerm_subnet" "db-subnet" {
  name                 = "db-subnet-${var.tag}"
  resource_group_name  = var.azurerm_resource_group.name
  virtual_network_name = azurerm_virtual_network.app-vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

# NSG
resource "azurerm_network_security_group" "app-nsg" {
  name                = "app-nsg-${var.tag}"
  location            = var.location
  resource_group_name = var.azurerm_resource_group.name

  security_rule {
    name                       = "my-ip"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = var.allowed_ips
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.tag
  }
}

locals {
  subnets = {
    "ui-app-subnet" = azurerm_subnet.ui-app-subnet
    "api-app-subnet"  = azurerm_subnet.api-app-subnet
    "db-subnet"       = azurerm_subnet.db-subnet
  }
}

# Associate the nsg with both the api and frontend subnets
resource "azurerm_subnet_network_security_group_association" "nsg-association" {
  for_each                  = local.subnets
  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.app-nsg.id
}
