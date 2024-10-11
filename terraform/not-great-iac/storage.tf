resource "azurerm_storage_account" "main" {
  name                            = "tomaskubicastorageacc"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = true
  https_traffic_only_enabled      = false
  min_tls_version                 = "TLS1_0"
  public_network_access_enabled   = true
  local_user_enabled              = true
  shared_access_key_enabled       = true
  tags = {
    git_commit           = "35414944c7506069e7d7764c15c5c05284473fcd"
    git_file             = "terraform/not-great-iac/storage.tf"
    git_last_modified_at = "2024-10-03 18:51:45"
    git_last_modified_by = "tkubica12@gmail.com"
    git_modifiers        = "tkubica12"
    git_org              = "tkubica12"
    git_repo             = "ms-defender-apps"
    yor_name             = "main"
    yor_trace            = "98d79f5d-c6cb-4825-855a-00c26ea285ad"
  }
}
