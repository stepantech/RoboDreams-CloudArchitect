output "function_app_books_name" {
  value = azurerm_linux_function_app.books.name
}

output "function_app_books_rg" {
  value = azurerm_linux_function_app.books.resource_group_name
}

output "function_app_versionme_name" {
  value = azurerm_linux_function_app.versionme.name
}

output "function_app_versionme_rg" {
  value = azurerm_linux_function_app.versionme.resource_group_name
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name
}
