variable "prefix" {
  type        = string
  default     = "rd-greenblue"
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

variable "green_count" {
  type        = number
  default     = 2
  description = <<EOF
Number of green virtual machines.
EOF
}

variable "blue_count" {
  type        = number
  default     = 2
  description = <<EOF
Number of blue virtual machines.
EOF
}

variable "green_version" {
  type        = string
  default     = "1.0.0"
  description = <<EOF
Version of green virtual machines.
EOF
}

variable "blue_version" {
  type        = string
  default     = "2.0.0"
  description = <<EOF
Version of blue virtual machines.
EOF
}
