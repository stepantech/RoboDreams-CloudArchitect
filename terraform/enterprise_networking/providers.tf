terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~>2"
    }
  }
  backend "azurerm" { # Change this to "local" for local backend
    resource_group_name  = "rg-base"
    storage_account_name = "tomaskubica"
    container_name       = "tfstate"
    key                  = "cloud-arch-app-data.enterprise_networking.tfstate"
  }
}

provider "azurerm" {
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

    api_management {
      purge_soft_delete_on_destroy = true
      recover_soft_deleted         = false
    }
  }
}

provider "random" {
  # Configuration options
}
