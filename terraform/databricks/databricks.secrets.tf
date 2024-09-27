resource "databricks_secret_scope" "azure" {
  name = "azure"
}

resource "databricks_secret" "storage_account_name" {
  key          = "storage_account_name"
  string_value = azurerm_storage_account.main.name
  scope        = databricks_secret_scope.azure.id
}
