terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~>1"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~>1"
    }
  }
  backend "azurerm" { # Change this to "local" for local backend
    resource_group_name  = "rg-base"
    storage_account_name = "tomaskubicatf"
    container_name       = "tfstate"
    key                  = "cloud-arch-app-data.databricks.tfstate"
  }
}

provider "azurerm" {
  subscription_id = "673af34d-6b28-41dc-bc7b-f507418045e6" # Change this to your subscription ID

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }

    key_vault {
      purge_soft_delete_on_destroy               = true
      purge_soft_deleted_secrets_on_destroy      = true
      purge_soft_deleted_certificates_on_destroy = true
      recover_soft_deleted_secrets               = true
      recover_soft_deleted_certificates          = true
      recover_soft_deleted_key_vaults            = true
    }
  }
}

provider "random" {
  # Configuration options
}

provider "databricks" {
  host = azurerm_databricks_workspace.main.workspace_url
}
