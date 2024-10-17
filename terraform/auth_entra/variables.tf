variable "prefix" {
  type        = string
  default     = "rd-auth-entra"
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

variable "MAIN_CLIENT_ID" {
  type        = string
  description = "Main client ID"
}

variable "MAIN_CLIENT_SECRET" {
  type        = string
  description = "Main client secret"
}

variable "API_CLIENT_ID" {
  type        = string
  description = "API client ID"
}

variable "API_CLIENT_SECRET" {
  type        = string
  description = "API client secret"
}

variable "BACKGROUND_CLIENT_ID" {
  type        = string
  description = "Background client ID"
}

variable "BACKGROUND_CLIENT_SECRET" {
  type        = string
  description = "Background client secret"
}

variable "APIM_CLIENT_ID" {
  type        = string
  description = "APIM client ID"
}

variable "APIM_CLIENT_SECRET" {
  type        = string
  description = "APIM client secret"
}

variable "REDIRECT_PATH" {
  type        = string
  description = "Redirect path"
  default     = "/auth_response"
}

variable "AUTHORITY" {
  type        = string
  description = "Authority URL"
  default     = "https://login.microsoftonline.com/tkubica.net"
}

variable "ENTRA_SCOPES" {
  type        = list(string)
  description = "Entra scopes"
  default     = ["User.Read"]
}

variable "API_SCOPES" {
  type        = list(string)
  description = "API scopes"
  default     = ["api://tokubica-auth-entra-api/Stuff.Read"]
}

variable "API_SCOPES_CLIENT_CRED_FLOW" {
  type        = list(string)
  description = "API scopes for client credential flow"
  default     = ["api://tokubica-auth-entra-api/.default"]
}

variable "GRAPH_API_ENDPOINT" {
  type        = string
  description = "Graph API endpoint"
  default     = "https://graph.microsoft.com/v1.0/me"
}

variable "CUSTOM_API_ENDPOINT" {
  type        = string
  description = "Custom API endpoint"
  default     = "http://localhost:5001"
}

variable "FLASK_SECRET_KEY" {
  type        = string
  description = "Flask secret key"
  default     = "super_secret_key"
}

variable "PAGE_NAME" {
  type        = string
  description = "Page name"
  default     = "Robot Dreams demo"
}

variable "TENANT_ID" {
  type        = string
  description = "Tenant ID"
  default     = "6ce4f237-667f-43f5-aafd-cbef954adf97"
}
