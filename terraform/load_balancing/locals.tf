locals {
  base_name          = "${replace(var.prefix, "_", "-")}-${random_string.main.result}"
  base_name_nodash   = replace(local.base_name, "-", "")
  base_name_regional1 = "${local.base_name}-${lookup(local.short_region_lookup, var.location, "other")}"
  base_name_regional2 = "${local.base_name}-${lookup(local.short_region_lookup, var.location2, "other")}"

  short_region_lookup = {
    "swedencentral"      = "swc"
    "westeurope"         = "weu"
    "northeurope"        = "neu"
    "germanywestcentral" = "gwc"
    "francecentral"      = "frc"
    "eastus2"            = "eus2"
  }

  install_script = <<SCRIPT
#!/bin/bash
apt-get update
apt-get install -y nginx
echo "Hello from $HOSTNAME" > /var/www/html/index.html
SCRIPT

  install_script_v2 = <<SCRIPT
#!/bin/bash
apt-get update
apt-get install -y nginx
echo "NEW VERSION: Hello from $HOSTNAME" > /var/www/html/index.html
SCRIPT

  install_script_service2 = <<SCRIPT
#!/bin/bash
apt-get update
apt-get install -y nginx
echo "SERVICE2: Hello from $HOSTNAME" > /var/www/html/index.html
SCRIPT
}
