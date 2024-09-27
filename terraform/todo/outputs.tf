output "static_webapp_name" {
  value = azurerm_static_web_app.main.name
}

output "static_webapp_url" {
  value = "https://${azurerm_static_web_app.main.default_host_name}"
}

output "function_app_name" {
  value = azurerm_linux_function_app.todo.name
}

output "function_app_rg" {
  value = azurerm_linux_function_app.todo.resource_group_name
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name
}