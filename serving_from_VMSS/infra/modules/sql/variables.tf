variable "azurerm_resource_group" {
  type = any
}

variable "tag" {
  type = string
}

variable "name" {
  type        = string
  description = "Name for the MySQL DB, must be unique in the world"
}

variable "allowed_ips" {
  type = list(string)
}

variable "mysql_admin_pw" {
  type      = string
  sensitive = true
}

variable "mysql_admin_name" {
  type = string
}

variable "db_sku" {
  type = string
}

variable "location" {
  type = string
}

variable "db_subnet" {
  type = any
}

variable "app_vnet" {
  type = any
}

variable "allow_public_network_access" {
  type        = bool
  description = "Possible values are 'true' or 'false'"
}