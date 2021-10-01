output "network_rg_id" {
  value = azurerm_resource_group.network_rg.id
  description = "Azure Resource Group id for network resources."
}

output "network_rg_name" {
  value = azurerm_resource_group.network_rg.name
  description = "Azure Resource Group name for network resources."
}

output "virtual_network_id" {
  value = azurerm_virtual_network.virtual_network.id
  description = "Azure VNET id for network resources."
}

output "virtual_network_name" {
  value = azurerm_virtual_network.virtual_network.name
  description = "Azure VNET name."
}

output "virtual_network_route_table" {
  value = azurerm_route_table.vnet_route_table.id
  description = "Azure VNET Route Table id."
}

output "default_subnet_id" {
  value = azurerm_subnet.default_subnet.id
  description = "Azure subnet id for the default subnet."
}

output "default_subnet_name" {
  value = azurerm_subnet.default_subnet.name
  description = "Azure subnet name for the default subnet."
}

output "gateway_subnet_id" {
  value = azurerm_subnet.gateway_subnet.id
  description = "Azure subnet id for the VPN subnet."
}

output "ptp_vpn_local_gw_id" {
  value = azurerm_local_network_gateway.ptp_vpn_local_gw[*].id
  description = "Azure Local Gateway id for VPN."
  depends_on = [azurerm_local_network_gateway.ptp_vpn_local_gw]
}

output "ptp_vpn_virtual_gw_id" {
  value = azurerm_virtual_network_gateway.virtual_network_gateway[*].id
  description = "Azure Virtual Netowrk Gateway id for VPN."
  depends_on = [azurerm_virtual_network_gateway.virtual_network_gateway]
}

output "ptp_vpn_virtual_gw_ip" {
  value = azurerm_public_ip.virtual_network_gateway_public_ip[*].ip_address
  description = "Azure Virtual Netowrk Gateway ip for VPN."
  depends_on = [azurerm_virtual_network_gateway.virtual_network_gateway]
}
