terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.22.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "openvpn_rg" {
  name     = "openvpn-rg"
  location = var.region
  tags     = var.resource_tag
}