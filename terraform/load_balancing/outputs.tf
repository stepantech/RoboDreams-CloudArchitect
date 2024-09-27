output "endpoints" {
  value = {
    "l4_ip_fqdn"      = azurerm_public_ip.lb_location1.fqdn
    "l7_ip_fqdn"      = azurerm_public_ip.appgw_location1.fqdn
    "l7_global_fqdn"  = azurerm_cdn_frontdoor_endpoint.main.host_name
    "l4_global_fqdn"  = azurerm_public_ip.lb_global.fqdn
    "dns_global_fqdn" = azurerm_traffic_manager_profile.main.fqdn
  }
}
