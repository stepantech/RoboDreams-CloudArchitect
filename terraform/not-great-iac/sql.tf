resource "azurerm_mssql_server" "main" {
  name                          = "tomaskubicamssqlserver"
  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  version                       = "12.0"
  administrator_login           = "adminuser"
  administrator_login_password  = "veryGoodPassword123!"
  minimum_tls_version           = "1.0"
  public_network_access_enabled = true
  tags = {
    git_commit           = "35414944c7506069e7d7764c15c5c05284473fcd"
    git_file             = "terraform/not-great-iac/sql.tf"
    git_last_modified_at = "2024-10-03 18:51:45"
    git_last_modified_by = "tkubica12@gmail.com"
    git_modifiers        = "tkubica12"
    git_org              = "tkubica12"
    git_repo             = "ms-defender-apps"
    yor_name             = "main"
    yor_trace            = "a2ee3a94-5c85-4bc7-ac01-51c20ed3a472"
  }
}

resource "azurerm_mssql_firewall_rule" "main" {
  name             = "FirewallRule1"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}