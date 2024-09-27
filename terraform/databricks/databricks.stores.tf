// Metastore
resource "databricks_metastore" "main" {
  count         = var.existing_metastore_id != "" ? 0 : 1
  name          = "mymetastore"
  storage_root  = "abfss://silver@${azurerm_storage_account.main.name}.dfs.core.windows.net"
  owner         = "account users"
  force_destroy = true

  lifecycle {
    ignore_changes = [delta_sharing_scope]
  }
}

locals {
  metastore_id = var.existing_metastore_id != "" ? var.existing_metastore_id : databricks_metastore.main[0].id
}

resource "databricks_metastore_assignment" "main" {
  metastore_id = local.metastore_id
  workspace_id = azurerm_databricks_workspace.main.workspace_id
}

// Catalog
resource "databricks_catalog" "main" {
  metastore_id  = local.metastore_id
  name          = "mycatalog"
  force_destroy = true

  depends_on = [
    databricks_metastore_assignment.main
  ]
}

// Schema (database)
resource "databricks_schema" "main" {
  catalog_name  = databricks_catalog.main.id
  name          = "mydb"
  force_destroy = true
}

// Storage access - connector
resource "azurerm_databricks_access_connector" "main" {
  name                = "dbw-ac-${local.base_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  identity {
    type = "SystemAssigned"
  }
}

// Storage access - managed identity credentials (for direct access to raw data)
resource "databricks_storage_credential" "external_mi" {
  name = "mi_credential"

  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.main.id
  }

  depends_on = [
    databricks_metastore_assignment.main
  ]
}

resource "databricks_external_location" "bronze" {
  name            = "bronze"
  url             = "abfss://bronze@${azurerm_storage_account.main.name}.dfs.core.windows.net"
  credential_name = databricks_storage_credential.external_mi.id

  depends_on = [
    databricks_metastore_assignment.main
  ]
}

resource "databricks_grants" "external_creds" {
  storage_credential = databricks_storage_credential.external_mi.id

  grant {
    principal  = "account users"
    privileges = ["READ_FILES"]
  }
}

