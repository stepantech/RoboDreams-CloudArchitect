resource "azurerm_network_security_group" "location1" {
  name                = "nsg-${local.base_name_regional1}-web"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_network_security_group" "location2" {
  name                = "nsg-${local.base_name_regional2}-web"
  location            = var.location2
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_network_security_rule" "location1" {
  name                        = "allow-http"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.location1.name
}

resource "azurerm_network_security_rule" "location2" {
  name                        = "allow-http"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.location2.name
}

resource "azurerm_subnet_network_security_group_association" "location1" {
  subnet_id                 = azurerm_subnet.location1.id
  network_security_group_id = azurerm_network_security_group.location1.id
}

resource "azurerm_subnet_network_security_group_association" "location2" {
  subnet_id                 = azurerm_subnet.location2.id
  network_security_group_id = azurerm_network_security_group.location2.id
}
