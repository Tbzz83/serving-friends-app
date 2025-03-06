## Frontend LB
#resource "azurerm_public_ip" "fe-lb-pip" {
#  name                = "fe-lb-pip-${var.tag}"
#  location            = var.location
#  resource_group_name = var.azurerm_resource_group.name
#  allocation_method   = "Static"
#}
#
#resource "azurerm_lb" "fe-lb" {
#  name                = "fe-lb-${var.tag}"
#  location            = var.location
#  resource_group_name = var.azurerm_resource_group.name
#
#  frontend_ip_configuration {
#    name                 = "PublicIPAddress"
#    public_ip_address_id = azurerm_public_ip.fe-lb-pip.id
#  }
#}
#
#resource "azurerm_lb_rule" "fe-lb-rule" {
#  loadbalancer_id                = azurerm_lb.fe-lb.id
#  name                           = "fe-lb-rule-${var.tag}"
#  protocol                       = "Tcp"
#  frontend_port                  = 80
#  backend_port                   = 80 
#  frontend_ip_configuration_name = "PublicIPAddress"
#  probe_id = azurerm_lb_probe.fehealthprobe.id
#  backend_address_pool_ids = [azurerm_lb_backend_address_pool.febpepool.id]
#}
#
#resource "azurerm_lb_backend_address_pool" "febpepool" {
#  loadbalancer_id = azurerm_lb.fe-lb.id
#  name            = "FEBackEndAddressPool-${var.tag}"
#}
#
#resource "azurerm_lb_nat_pool" "fefelbnatpool" {
#  resource_group_name            = var.azurerm_resource_group.name
#  name                           = "ssh"
#  loadbalancer_id                = azurerm_lb.fe-lb.id
#  protocol                       = "Tcp"
#  frontend_port_start            = 50000
#  frontend_port_end              = 50119
#  backend_port                   = 22
#  frontend_ip_configuration_name = "PublicIPAddress"
#}
#
#resource "azurerm_lb_probe" "fehealthprobe" {
#  loadbalancer_id = azurerm_lb.fe-lb.id
#  name            = "http-probe"
#  protocol        = "Http"
#  request_path    = "/health"
#  port            = 8080
#}
#
## Frontend VMSS
#resource "azurerm_linux_virtual_machine_scale_set" "frontend-vmss" {
#  name                = "frontend-vmss-${var.tag}"
#  resource_group_name = var.azurerm_resource_group.name
#  location            = var.location
#  sku                 = var.vmss_sku
#  instances           = 1
#  admin_username      = "adminuser"
#  depends_on = [ azurerm_lb_rule.fe-lb-rule ]
#
#  upgrade_mode = "Automatic"
#  health_probe_id = azurerm_lb_probe.fehealthprobe.id 
#
#  admin_ssh_key {
#    username   = "adminuser"
#    public_key = file("~/.ssh/edu_az_vms.pub")
#  }
#
#  source_image_reference {
#    publisher = "Canonical"
#    offer     = "0001-com-ubuntu-server-jammy"
#    sku       = "22_04-lts"
#    version   = "latest"
#  }
#
#  os_disk {
#    storage_account_type = "Standard_LRS"
#    caching              = "ReadWrite"
#  }
#
#  network_interface {
#    name    = "vmss-nic-${var.tag}"
#    primary = true
#
#    ip_configuration {
#      name      = "internal"
#      primary   = true
#      subnet_id = var.frontend-subnet.id
#      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.febpepool.id]
#      load_balancer_inbound_nat_rules_ids = [azurerm_lb_nat_pool.fefelbnatpool.id]
#    }
#  }
#
#}
#
## Frontend autoscale settings
#resource "azurerm_monitor_autoscale_setting" "frontend-autoscaling-setting" {
#  name                = "frontend-autoscaling-setting-${var.tag}"
#  resource_group_name = var.azurerm_resource_group.name
#  location            = var.location
#  target_resource_id  = azurerm_linux_virtual_machine_scale_set.frontend-vmss.id
#
#  profile {
#    name = "defaultProfile"
#
#    capacity {
#      default = 1
#      minimum = 1
#      maximum = 3
#    }
#
#    rule {
#      metric_trigger {
#        metric_name        = "Percentage CPU"
#        metric_resource_id = azurerm_linux_virtual_machine_scale_set.frontend-vmss.id
#        time_grain         = "PT1M"
#        statistic          = "Average"
#        time_window        = "PT5M"
#        time_aggregation   = "Average"
#        operator           = "GreaterThan"
#        threshold          = 75
#        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
#      }
#
#      scale_action {
#        direction = "Increase"
#        type      = "ChangeCount"
#        value     = "1"
#        cooldown  = "PT1M"
#      }
#    }
#
#    rule {
#      metric_trigger {
#        metric_name        = "Percentage CPU"
#        metric_resource_id = azurerm_linux_virtual_machine_scale_set.frontend-vmss.id
#        time_grain         = "PT1M"
#        statistic          = "Average"
#        time_window        = "PT5M"
#        time_aggregation   = "Average"
#        operator           = "LessThan"
#        threshold          = 25
#      }
#
#      scale_action {
#        direction = "Decrease"
#        type      = "ChangeCount"
#        value     = "1"
#        cooldown  = "PT1M"
#      }
#    }
#  }
#
#  predictive {
#    scale_mode      = "Enabled"
#    look_ahead_time = "PT5M"
#  }
#
#  notification {
#    email {
#      custom_emails = [var.my_personal_email]
#    }
#  }
#}
#
## Backend LB
#resource "azurerm_lb" "be-lb" {
#  name                = "be-lb-${var.tag}"
#  location            = var.location
#  resource_group_name = var.azurerm_resource_group.name
#
#  frontend_ip_configuration {
#    name                 = "PrivateIPAddress"
#    private_ip_address_allocation = "Dynamic"
#    subnet_id = var.backend-subnet.id
#  }
#}
#
#resource "azurerm_lb_nat_pool" "bebelbnatpool" {
#  resource_group_name            = var.azurerm_resource_group.name
#  name                           = "ssh"
#  loadbalancer_id                = azurerm_lb.be-lb.id
#  protocol                       = "Tcp"
#  frontend_port_start            = 50000
#  frontend_port_end              = 50119
#  backend_port                   = 22
#  frontend_ip_configuration_name = "PrivateIPAddress"
#}
#
#resource "azurerm_lb_backend_address_pool" "bebpepool" {
#  loadbalancer_id = azurerm_lb.be-lb.id
#  name            = "BEBackEndAddressPool-${var.tag}"
#}
#
#resource "azurerm_lb_rule" "be-lb-rule" {
#  loadbalancer_id                = azurerm_lb.be-lb.id
#  name                           = "be-lb-rule-${var.tag}"
#  protocol                       = "Tcp"
#  frontend_port                  = 5000 
#  backend_port                   = 5000 
#  frontend_ip_configuration_name = "PrivateIPAddress"
#  probe_id = azurerm_lb_probe.behealthprobe.id
#  backend_address_pool_ids = [azurerm_lb_backend_address_pool.bebpepool.id]
#}
#
#resource "azurerm_lb_probe" "behealthprobe" {
#  loadbalancer_id = azurerm_lb.be-lb.id
#  name            = "http-probe"
#  protocol        = "Http"
#  request_path    = "/health"
#  port            = 8080
#}
#
## Frontend VMSS
#resource "azurerm_linux_virtual_machine_scale_set" "backend-vmss" {
#  name                = "backend-vmss-${var.tag}"
#  resource_group_name = var.azurerm_resource_group.name
#  location            = var.location
#  sku                 = var.vmss_sku
#  instances           = 1
#  admin_username      = "adminuser"
#  depends_on = [ azurerm_lb_rule.be-lb-rule ]
#
#  upgrade_mode = "Automatic"
#  health_probe_id = azurerm_lb_probe.behealthprobe.id 
#
#  admin_ssh_key {
#    username   = "adminuser"
#    public_key = file("~/.ssh/edu_az_vms.pub")
#  }
#
#  source_image_reference {
#    publisher = "Canonical"
#    offer     = "0001-com-ubuntu-server-jammy"
#    sku       = "22_04-lts"
#    version   = "latest"
#  }
#
#  os_disk {
#    storage_account_type = "Standard_LRS"
#    caching              = "ReadWrite"
#  }
#
#  network_interface {
#    name    = "vmss-nic-${var.tag}"
#    primary = true
#
#    ip_configuration {
#      name      = "internal"
#      primary   = true
#      subnet_id = var.frontend-subnet.id
#      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bebpepool.id]
#      load_balancer_inbound_nat_rules_ids = [azurerm_lb_nat_pool.bebelbnatpool.id]
#    }
#  }
#
#}
#
## Frontend autoscale settings
#resource "azurerm_monitor_autoscale_setting" "backend-autoscaling-setting" {
#  name                = "backend-autoscaling-setting-${var.tag}"
#  resource_group_name = var.azurerm_resource_group.name
#  location            = var.location
#  target_resource_id  = azurerm_linux_virtual_machine_scale_set.backend-vmss.id
#
#  profile {
#    name = "defaultProfile"
#
#    capacity {
#      default = 1
#      minimum = 1
#      maximum = 3
#    }
#
#    rule {
#      metric_trigger {
#        metric_name        = "Percentage CPU"
#        metric_resource_id = azurerm_linux_virtual_machine_scale_set.backend-vmss.id
#        time_grain         = "PT1M"
#        statistic          = "Average"
#        time_window        = "PT5M"
#        time_aggregation   = "Average"
#        operator           = "GreaterThan"
#        threshold          = 75
#        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
#      }
#
#      scale_action {
#        direction = "Increase"
#        type      = "ChangeCount"
#        value     = "1"
#        cooldown  = "PT1M"
#      }
#    }
#
#    rule {
#      metric_trigger {
#        metric_name        = "Percentage CPU"
#        metric_resource_id = azurerm_linux_virtual_machine_scale_set.backend-vmss.id
#        time_grain         = "PT1M"
#        statistic          = "Average"
#        time_window        = "PT5M"
#        time_aggregation   = "Average"
#        operator           = "LessThan"
#        threshold          = 25
#      }
#
#      scale_action {
#        direction = "Decrease"
#        type      = "ChangeCount"
#        value     = "1"
#        cooldown  = "PT1M"
#      }
#    }
#  }
#
#  predictive {
#    scale_mode      = "Enabled"
#    look_ahead_time = "PT5M"
#  }
#
#  notification {
#    email {
#      custom_emails = [var.my_personal_email]
#    }
#  }
#}

# backend public IP
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
      subnet_id = var.frontend-subnet.id 
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
