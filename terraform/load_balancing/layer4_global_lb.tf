resource "azurerm_public_ip" "lb_global" {
  name                = "pip-${local.base_name}-lbglobal"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Global"
  domain_name_label   = "${local.base_name}-lbglobal"
}

resource "azurerm_lb" "lb_global" {
  name                = "lb-${local.base_name}-global"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"
  sku_tier            = "Global"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_global.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb_global" {
  loadbalancer_id = azurerm_lb.lb_global.id
  name            = "pool"
}

resource "azurerm_lb_backend_address_pool_address" "lb_global_location1" {
  name                                = "location1"
  backend_address_pool_id             = azurerm_lb_backend_address_pool.lb_global.id
  backend_address_ip_configuration_id = azurerm_lb.lb_location1.frontend_ip_configuration[0].id
}

resource "azurerm_lb_backend_address_pool_address" "lb_global_location2" {
  name                                = "location2"
  backend_address_pool_id             = azurerm_lb_backend_address_pool.lb_global.id
  backend_address_ip_configuration_id = azurerm_lb.lb_location2.frontend_ip_configuration[0].id
}

resource "azurerm_lb_rule" "lb_global" {
  loadbalancer_id                = azurerm_lb.lb_global.id
  name                           = "web"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.lb_global.frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_global.id]
}
