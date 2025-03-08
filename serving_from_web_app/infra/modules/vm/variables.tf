variable "azurerm_resource_group" {
  type = any
}

variable "tag" {
  type = string
}

variable "vm_sku" {
  type = string
}

variable "ssh_key_path" {
  type = string
}

variable "allowed_ips" {
  type = list(string)
  sensitive = true
}

variable "dev-vm-subnet" {
  type = any
}

variable "location" {
  type = string
  
}

