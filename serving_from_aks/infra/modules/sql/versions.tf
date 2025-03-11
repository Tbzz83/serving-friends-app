terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.22.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "2.2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}