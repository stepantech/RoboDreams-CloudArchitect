locals {
  base_name          = "${replace(var.prefix, "_", "-")}-${random_string.main.result}"
  base_name_nodash   = replace(local.base_name, "-", "")
  base_name_regional1 = "${local.base_name}-${lookup(local.short_region_lookup, var.location, "other")}"
  base_name_regional2 = "${local.base_name}-${lookup(local.short_region_lookup, var.location2, "other")}"
  base_name_regional3 = "${local.base_name}-${lookup(local.short_region_lookup, var.location3, "other")}"

  short_region_lookup = {
    "swedencentral"      = "swc"
    "westeurope"         = "weu"
    "northeurope"        = "neu"
    "germanywestcentral" = "gwc"
    "francecentral"      = "frc"
  }
}
