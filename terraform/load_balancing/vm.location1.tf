// Public IPs for service2 and newversion (for this demo those do not use L4 balancer)
resource "azurerm_public_ip" "service2_location1" {
  name                = "pip-${local.base_name_regional1}-service2"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "${local.base_name_regional1}-service2"
}

resource "azurerm_public_ip" "newversion_location1" {
  name                = "pip-${local.base_name_regional1}-newversion"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "${local.base_name_regional1}-newversion"
}

// NICs
resource "azurerm_network_interface" "vm1_location1" {
  name                = "nic-${local.base_name_regional1}-vm1"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.location1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "vm2_location1" {
  name                = "nic-${local.base_name_regional1}-vm2"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.location1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "vm3_location1" {
  name                = "nic-${local.base_name_regional1}-vm3"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.location1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.newversion_location1.id
  }
}

resource "azurerm_network_interface" "vm4_location1" {
  name                = "nic-${local.base_name_regional1}-vm4"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.location1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.service2_location1.id
  }
}

// VMs
resource "azurerm_linux_virtual_machine" "vm1_location1" {
  name                            = "vm-${local.base_name_regional1}-1"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.main.name
  size                            = "Standard_B1s"
  admin_username                  = "adminuser"
  admin_password                  = "Azure12345678"
  disable_password_authentication = false
  user_data                       = base64encode(local.install_script)
  zone                            = 1

  network_interface_ids = [
    azurerm_network_interface.vm1_location1.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  boot_diagnostics {}

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_linux_virtual_machine" "vm2_location1" {
  name                            = "vm-${local.base_name_regional1}-2"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.main.name
  size                            = "Standard_B1s"
  admin_username                  = "adminuser"
  admin_password                  = "Azure12345678"
  disable_password_authentication = false
  user_data                       = base64encode(local.install_script)
  zone                            = 2

  network_interface_ids = [
    azurerm_network_interface.vm2_location1.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  boot_diagnostics {}

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_linux_virtual_machine" "vm3_location1" {
  name                            = "vm-${local.base_name_regional1}-3"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.main.name
  size                            = "Standard_B1s"
  admin_username                  = "adminuser"
  admin_password                  = "Azure12345678"
  disable_password_authentication = false
  user_data                       = base64encode(local.install_script_v2)
  zone                            = 1

  network_interface_ids = [
    azurerm_network_interface.vm3_location1.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  boot_diagnostics {}

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_linux_virtual_machine" "vm4_location1" {
  name                            = "vm-${local.base_name_regional1}-4"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.main.name
  size                            = "Standard_B1s"
  admin_username                  = "adminuser"
  admin_password                  = "Azure12345678"
  disable_password_authentication = false
  user_data                       = base64encode(local.install_script_service2)
  zone                            = 1

  network_interface_ids = [
    azurerm_network_interface.vm4_location1.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  boot_diagnostics {}

  identity {
    type = "SystemAssigned"
  }
}