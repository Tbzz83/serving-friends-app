# Shared image gallery for VM images
resource "azurerm_shared_image_gallery" "app-gallery" {
  name                = "app_gallery_${var.tag}"
  resource_group_name = var.azurerm_resource_group.name
  location            = var.location
  description         = "Shared images and things."

  tags = {
    environment = var.tag
  }
}

# image public IP
resource "azurerm_public_ip" "image-pip" {
    count = 2
    name = "image-pip-${count.index}"
    resource_group_name = var.azurerm_resource_group.name
    location = var.location
    allocation_method = "Static"

    tags = {
      environment = var.tag
    }
}

# Image NIC
resource "azurerm_network_interface" "image-nic" {
    count = 2
    name = "image-nic-${count.index}"
    resource_group_name = var.azurerm_resource_group.name
    location = var.location

    ip_configuration {
      name = "image-ipconfig"
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.image-pip[count.index].id
      subnet_id = var.imaging-subnet.id 
    }

    tags = {
      environment = var.tag
    }
}

# VMs for images
resource "azurerm_linux_virtual_machine" "image-server" {
  count = 2
  name = "image-server-${count.index}"
  resource_group_name = var.azurerm_resource_group.name
  location = var.location
  disable_password_authentication = true
  size = "Standard_B1s"
  admin_username = "adminuser"

  network_interface_ids = [azurerm_network_interface.image-nic[count.index].id]

  admin_ssh_key {
    username = "adminuser"
    public_key = file("~/.ssh/edu_az_vms.pub")
  }

  os_disk {
      caching = "ReadWrite"
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