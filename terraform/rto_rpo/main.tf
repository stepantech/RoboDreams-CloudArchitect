resource "azurerm_resource_group" "main" {
  name     = "rg-${local.base_name}"
  location = var.location
}

resource "azurerm_resource_group" "secondary" {
  name     = "rg-${local.secondary_name}"
  location = var.location_secondary
}

resource "random_string" "main" {
  length  = 4
  special = false
  upper   = false
  numeric = false
  lower   = true
}

data "azurerm_client_config" "current" {}
