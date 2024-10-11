resource "azurerm_resource_group" "main" {
  name     = "rg-not-great-iac"
  location = "swedencentral"
  tags = {
    yor_name             = "main"
    yor_trace            = "cb2ed409-f813-4d6a-b00d-023da85236c1"
    git_commit           = "dbaa4fd934d201d4b09700a02f00f5dbe98cf97e"
    git_file             = "terraform/not-great-iac/main.tf"
    git_last_modified_at = "2024-10-03 15:05:53"
    git_last_modified_by = "tkubica12@gmail.com"
    git_modifiers        = "tkubica12"
    git_org              = "tkubica12"
    git_repo             = "ms-defender-apps"
  }
}