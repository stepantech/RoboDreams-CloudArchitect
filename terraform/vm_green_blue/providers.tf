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
  }
  backend "azurerm" { # Change this to "local" for local backend
    resource_group_name  = "rg-base-dev-sc-001"
    storage_account_name = "pscloudarchitecttf"
    container_name       = "tfstate"
    key                  = "cloud-arch-app-data.vm_green_blue.tfstate"
    use_azuread_auth     = true
    subscription_id      = "7568475b-3f98-4c3f-8bbb-05e248ff70b4"
  }
}

provider "azurerm" {
  subscription_id = "7568475b-3f98-4c3f-8bbb-05e248ff70b4"
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