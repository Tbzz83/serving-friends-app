# frontend public IP
resource "azurerm_public_ip" "frontend-pip" {
    name = "frontend-pip"
    resource_group_name = var.azurerm_resource_group.name
    location = var.azurerm_resource_group.location
    allocation_method = "Static"

    tags = {
      environment = var.tag
    }
}

# backend public IP
resource "azurerm_public_ip" "backend-pip" {
    name = "backend-pip"
    resource_group_name = var.azurerm_resource_group.name
    location = var.azurerm_resource_group.location
    allocation_method = "Static"

    tags = {
      environment = var.tag
    }
}

# frontend NIC
resource "azurerm_network_interface" "frontend-nic" {
    name = "frontend-nic"
    resource_group_name = var.azurerm_resource_group.name
    location = var.azurerm_resource_group.location

    ip_configuration {
      name = "frontend-ipconfig"
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.frontend-pip.id
      subnet_id = var.frontend-subnet.id 
    }

    tags = {
      environment = var.tag
    }
}

# backend NIC
resource "azurerm_network_interface" "backend-nic" {
    name = "backend-nic"
    resource_group_name = var.azurerm_resource_group.name
    location = var.azurerm_resource_group.location

    ip_configuration {
      name = "backend-ipconfig"
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.backend-pip.id
      subnet_id = var.backend-subnet.id 
    }

    tags = {
      environment = var.tag
    }
}

# Frontend VM
resource "azurerm_linux_virtual_machine" "frontend-server" {
    name = "frontend-server"
    resource_group_name = var.azurerm_resource_group.name
    location = var.azurerm_resource_group.location
    disable_password_authentication = true
    size = "Standard_B1s"
    admin_username = "adminuser"

    network_interface_ids = [azurerm_network_interface.frontend-nic.id]

    identity {
      type = "UserAssigned"
      identity_ids = [var.user_assigned_identity.id]
    }
    
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

# Backend VM
resource "azurerm_linux_virtual_machine" "backend-server" {
    name = "backend-server"
    resource_group_name = var.azurerm_resource_group.name
    location = var.azurerm_resource_group.location
    disable_password_authentication = true
    size = "Standard_B1s"
    admin_username = "adminuser"

    network_interface_ids = [azurerm_network_interface.backend-nic.id]
    
    identity {
      type = "UserAssigned"
      identity_ids = [var.user_assigned_identity.id]
    }

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