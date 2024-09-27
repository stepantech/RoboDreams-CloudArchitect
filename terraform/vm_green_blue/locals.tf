locals {
  base_name        = "${replace(var.prefix, "_", "-")}-${random_string.main.result}"
  base_name_nodash = replace(local.base_name, "-", "")

  vm_base_script = <<EOF
#!/bin/bash
apt-get update
apt-get install -y nginx
systemctl start nginx
systemctl enable nginx
EOF

  vm_green_content = <<EOF
echo "VERSION ${var.green_version}: Hello from $HOSTNAME" > /var/www/html/index.html
EOF

  vm_blue_content = <<EOF
echo "VERSION ${var.blue_version}: Hello from $HOSTNAME" > /var/www/html/index.html
EOF

  vm_green_script = base64encode("${local.vm_base_script}\n${local.vm_green_content}")
  vm_blue_script  = base64encode("${local.vm_base_script}\n${local.vm_blue_content}")
}
