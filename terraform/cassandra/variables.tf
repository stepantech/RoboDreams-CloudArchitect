variable "prefix" {
  type        = string
  default     = "rd-cassandra"
  description = <<EOF
Prefix for resources.
Preferably 2-4 characters long without special characters, lowercase.
EOF
}

variable "location" {
  type        = string
  default     = "swedencentral"
  description = <<EOF
Azure region for resources.

Examples: swedencentral, westeurope, northeurope, germanywestcentral.
EOF
}

variable "location2" {
  type        = string
  default     = "germanywestcentral"
  description = <<EOF
Azure region for resources.

Examples: swedencentral, westeurope, northeurope, germanywestcentral.
EOF
}

variable "location3" {
  type        = string
  default     = "francecentral"
  description = <<EOF
Azure region for resources.

Examples: swedencentral, westeurope, northeurope, germanywestcentral.
EOF
}

variable "cosmos_db_service_principal_id" {
  type        = string
  default     = "541f6bff-fa6e-44a0-8e8f-3f5b59e94fe3"
  description = <<EOF
The object ID of the Azure AD service principal for Azure Cosmos DB.
See (https://learn.microsoft.com/en-us/azure/managed-instance-apache-cassandra/add-service-principal)
EOF
}
