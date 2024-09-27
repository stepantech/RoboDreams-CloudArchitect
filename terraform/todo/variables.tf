variable "prefix" {
  type        = string
  default     = "rd-todo"
  description = <<EOF
Prefix for resources.
Preferably 2-4 characters long without special characters, lowercase.
EOF
}

variable "location" {
  type        = string
  default     = "germanywestcentral"
  description = <<EOF
Azure region for resources.

Examples: swedencentral, westeurope, northeurope, germanywestcentral.
EOF
}

variable "AZURE_OPENAI_API_KEY" {
  type        = string
  description = <<EOF
API key for Azure OpenAI service.
EOF
}

variable "AZURE_OPENAI_ENDPOINT" {
  type        = string
  description = <<EOF
Endpoint for Azure OpenAI service.
EOF
}
