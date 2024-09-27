resource "azurerm_service_plan" "main" {
  name                = "fsp-${local.base_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "books" {
  name                                           = "func-books-${local.base_name}"
  resource_group_name                            = azurerm_resource_group.main.name
  location                                       = azurerm_resource_group.main.location
  storage_account_name                           = azurerm_storage_account.main.name
  service_plan_id                                = azurerm_service_plan.main.id
  webdeploy_publish_basic_authentication_enabled = false
  ftp_publish_basic_authentication_enabled       = false
  storage_uses_managed_identity                  = true

  site_config {
    application_insights_connection_string = azurerm_application_insights.main.connection_string
    application_insights_key               = azurerm_application_insights.main.instrumentation_key

    application_stack {
      python_version = "3.11"
    }
  }

  app_settings = {
    "AzureWebJobsStorage__blobServiceUri"   = azurerm_storage_account.main.primary_blob_endpoint,
    "AzureWebJobsStorage__queueServiceUri"  = azurerm_storage_account.main.primary_queue_endpoint,
    "AzureWebJobsStorage__tableServiceUri"  = azurerm_storage_account.main.primary_table_endpoint,
    "AzureWebJobsStorage__accountName"      = azurerm_storage_account.main.name,
    "CosmosDBConnection__accountEndpoint"   = azurerm_cosmosdb_account.main.endpoint,
    "CosmosDBConnection__tenantId"          = data.azurerm_client_config.current.tenant_id,
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.main.instrumentation_key,
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.main.connection_string,
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
      app_settings["APPINSIGHTS_INSTRUMENTATIONKEY"],
      app_settings["APPLICATIONINSIGHTS_CONNECTION_STRING"],
      app_settings["AzureWebJobsStorage__accountName"],
    ]
  }
}

resource "azurerm_linux_function_app" "versionme" {
  name                                           = "func-versionme-${local.base_name}"
  resource_group_name                            = azurerm_resource_group.main.name
  location                                       = azurerm_resource_group.main.location
  storage_account_name                           = azurerm_storage_account.main.name
  service_plan_id                                = azurerm_service_plan.main.id
  webdeploy_publish_basic_authentication_enabled = false
  ftp_publish_basic_authentication_enabled       = false
  storage_uses_managed_identity                  = true

  site_config {
    application_insights_connection_string = azurerm_application_insights.main.connection_string
    application_insights_key               = azurerm_application_insights.main.instrumentation_key

    application_stack {
      python_version = "3.11"
    }
  }

  app_settings = {
    "AzureWebJobsStorage__blobServiceUri"   = azurerm_storage_account.main.primary_blob_endpoint,
    "AzureWebJobsStorage__queueServiceUri"  = azurerm_storage_account.main.primary_queue_endpoint,
    "AzureWebJobsStorage__tableServiceUri"  = azurerm_storage_account.main.primary_table_endpoint,
    "AzureWebJobsStorage__accountName"      = azurerm_storage_account.main.name,
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.main.instrumentation_key,
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.main.connection_string,
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
      app_settings["APPINSIGHTS_INSTRUMENTATIONKEY"],
      app_settings["APPLICATIONINSIGHTS_CONNECTION_STRING"],
      app_settings["AzureWebJobsStorage__accountName"],
    ]
  }
}
