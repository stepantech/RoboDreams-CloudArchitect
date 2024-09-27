variable "prefix" {
  type        = string
  default     = "rd-dbx"
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

variable "existing_metastore_id" {
  type        = string
  default     = ""
  description = <<EOF
Existing metastore ID to use if present in region. 
If not, do not specify any and Terraform will create one.
EOF
}
