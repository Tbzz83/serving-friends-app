resource "azurerm_public_ip" "dev-pip" {
  name                = "dev-pip-${var.tag}"
  resource_group_name = var.azurerm_resource_group.name
  location            = var.location
  allocation_method   = "Static"

  tags = {
    environment = var.tag
  }
}

resource "azurerm_network_interface" "dev-nic" {
  name                = "dev-nic-${var.tag}"
  location            = var.location
  resource_group_name = var.azurerm_resource_group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.dev-vm-subnet.id
    public_ip_address_id = azurerm_public_ip.dev-pip.id 
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_linux_virtual_machine" "dev-vm" {
  name                = "dev-vm-${var.tag}"
  resource_group_name = var.azurerm_resource_group.name
  location            = var.location
  size                = var.vm_sku
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.dev-nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file(var.ssh_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    environment = var.tag
  }
}

# vm NSG
resource "azurerm_network_security_group" "dev-vm-nsg" {
  name                = "dev-vm-nsg-${var.tag}"
  location            = var.location
  resource_group_name = var.azurerm_resource_group.name

  security_rule {
    name                       = "my-ip"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = var.allowed_ips
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.tag
  }
}

# Associate NSG with dev-vm-subnet
resource "azurerm_subnet_network_security_group_association" "dev-vm-subnet-assoc" {
  subnet_id                 = var.dev-vm-subnet.id
  network_security_group_id = azurerm_network_security_group.dev-vm-nsg.id
}