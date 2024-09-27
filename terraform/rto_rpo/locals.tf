locals {
  base_name             = "${replace(var.prefix, "_", "-")}-${random_string.main.result}"
  base_name_nodash      = replace(local.base_name, "-", "")
  secondary_name        = "${replace(var.prefix, "_", "-")}-secondary-${random_string.main.result}"
  secindary_name_nodash = replace(local.base_name, "-", "")
}
