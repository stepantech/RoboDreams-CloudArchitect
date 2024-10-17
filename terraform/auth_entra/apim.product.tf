resource "azurerm_api_management_product" "main" {
  product_id            = "demo-product"
  api_management_name   = azurerm_api_management.main.name
  resource_group_name   = azurerm_resource_group.main.name
  display_name          = "Demo Product"
  subscription_required = false
  approval_required     = false
  published             = true
}
