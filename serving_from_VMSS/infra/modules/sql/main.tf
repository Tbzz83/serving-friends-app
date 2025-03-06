# Mysql db
resource "azurerm_mysql_flexible_server" "friendsapp-mysql" {
  name                   = var.name
  resource_group_name    = var.azurerm_resource_group.name
  location               = var.location
  administrator_login    = var.mysql_admin_name
  administrator_password = var.mysql_admin_pw
  sku_name               = var.db_sku
  zone                   = 2

  tags = {
    environment = var.tag
  }
}

# Firewall rule allow dev IPS
resource "azurerm_mysql_flexible_server_firewall_rule" "devs-allowed" {
  count               = length(var.allowed_ips)
  name                = "devs-allowed${count.index}"
  resource_group_name = var.azurerm_resource_group.name
  server_name         = azurerm_mysql_flexible_server.friendsapp-mysql.name
  start_ip_address    = var.allowed_ips[count.index]
  end_ip_address      = var.allowed_ips[count.index]
}

# Currently no support for disabling public access through tf
resource "azapi_resource_action" "allow_public_network_access" {
  type        = "Microsoft.DBforMySQL/flexibleServers@2023-06-30"
  resource_id = azurerm_mysql_flexible_server.friendsapp-mysql.id
  method      = "PATCH"

  body = {
    properties = {
      network = {
        publicNetworkAccess = var.allow_public_network_access ? "Enabled" : "Disabled"
      }
    }
  }

  depends_on = [azurerm_mysql_flexible_server_firewall_rule.devs-allowed]
}

# Dev database
resource "azurerm_mysql_flexible_database" "friendsapp" {
  name                = "friendsapp-${var.tag}"
  resource_group_name = var.azurerm_resource_group.name
  server_name         = azurerm_mysql_flexible_server.friendsapp-mysql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

# Private DNS zone for UI
resource "azurerm_private_dns_zone" "db-priv-dns" {
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = var.azurerm_resource_group.name
}

# Virtual network link to private DNS 
resource "azurerm_private_dns_zone_virtual_network_link" "db-priv-dns-link" {
  name                  = "db-priv-dns-link-${var.tag}"
  resource_group_name   = var.azurerm_resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.db-priv-dns.name
  virtual_network_id    = var.app_vnet.id
  registration_enabled  = false
}

# Private endpoint for MySQL DB
resource "azurerm_private_endpoint" "db-endpoint" {
  name                = "db-endpoint-${var.tag}"
  location            = var.location
  resource_group_name = var.azurerm_resource_group.name
  subnet_id           = var.db_subnet.id

  private_dns_zone_group {
    name                 = "privatednszonegroup"
    private_dns_zone_ids = [azurerm_private_dns_zone.db-priv-dns.id]
  }

  private_service_connection {
    name                           = "db-privateserviceconnection"
    private_connection_resource_id = azurerm_mysql_flexible_server.friendsapp-mysql.id
    subresource_names              = ["mysqlServer"]
    is_manual_connection           = false
  }
}

