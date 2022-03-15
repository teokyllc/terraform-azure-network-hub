resource "azurerm_public_ip" "vnet_firewall_pip" {
  count               = "${var.enable_subnet_firewall == true ? 1 : 0}"
  name                = "${var.hub_vnet_name}-Firewall-PIP"
  location            = var.region
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "virtual_network_gateway_public_ip" {
  count               = "${var.enable_p2p_vpn == true ? 1 : 0}"
  name                = "${var.hub_vnet_name}-VGW-IP"
  location            = var.region
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_network_security_group" "vnet_nsg" {
  count               = "${var.enable_subnet_nsg == true ? 1 : 0}"
  name                = "${var.hub_vnet_name}-NSG"
  location            = var.region
  resource_group_name = var.resource_group_name

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_firewall" "vnet_firewall" {
  count               = "${var.enable_subnet_firewall == true ? 1 : 0}"
  name                = "${var.hub_vnet_name}-Firewall"
  location            = var.region
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall_subnet[count.index].id
    public_ip_address_id = azurerm_public_ip.vnet_firewall_pip[count.index].id
  }
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = var.hub_vnet_name
  address_space       = [var.vnet_cidr]
  location            = var.region
  resource_group_name = var.resource_group_name
  dns_servers         = var.dns_servers

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_route_table" "vnet_route_table" {
  name                          = var.hub_route_table_name
  location                      = var.region
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = var.disable_bgp_route_propagation

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_route" "route_to_internet" {
  count               = "${var.enable_subnet_firewall == true ? 0 : 1}"
  name                = "Internet"
  resource_group_name = var.resource_group_name
  route_table_name    = azurerm_route_table.vnet_route_table.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "Internet"
}

resource "azurerm_route" "route_to_local_vnet" {
  name                = "LocalVNET"
  resource_group_name = var.resource_group_name
  route_table_name    = azurerm_route_table.vnet_route_table.name
  address_prefix      = var.vnet_cidr
  next_hop_type       = "VnetLocal"
}

resource "azurerm_subnet" "default_subnet" {
  depends_on                = [azurerm_virtual_network.virtual_network]
  name                      = var.default_subnet_name
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.virtual_network.name
  address_prefixes          = [var.default_subnet_cidr]
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  count                     = "${var.enable_subnet_nsg == true ? 1 : 0}"
  subnet_id                 = azurerm_subnet.default_subnet.id
  network_security_group_id = azurerm_network_security_group.vnet_nsg[count.index].id
}

resource "azurerm_subnet_route_table_association" "default_subnet_route_table_association" {
  subnet_id      = azurerm_subnet.default_subnet.id
  route_table_id = azurerm_route_table.vnet_route_table.id
}

resource "azurerm_subnet" "gateway_subnet" {
  depends_on                = [azurerm_virtual_network.virtual_network]
  count                     = "${var.enable_p2p_vpn == true ? 1 : 0}"
  name                      = "GatewaySubnet"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.virtual_network.name
  address_prefixes          = [var.gateway_subnet_cidr]
}

resource "azurerm_subnet" "firewall_subnet" {
  count                = "${var.enable_subnet_firewall == true ? 1 : 0}"
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [var.firewall_subnet_cidr]
}

resource "azurerm_local_network_gateway" "ptp_vpn_local_gw" {
  count               = "${var.enable_p2p_vpn == true ? 1 : 0}"
  name                = var.ptp_vpn_remote_endpoint_name
  resource_group_name = var.resource_group_name
  location            = var.region
  gateway_fqdn        = var.ptp_vpn_remote_endpoint_fqdn
  address_space       = [var.ptp_vpn_remote_network]

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_virtual_network_gateway" "virtual_network_gateway" {
  count               = "${var.enable_p2p_vpn == true ? 1 : 0}"
  name                = "${var.hub_vnet_name}-VGW"
  location            = var.region
  resource_group_name = var.resource_group_name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  active_active       = var.vgw_active_active_mode
  enable_bgp          = var.ptp_vpn_enable_bgp
  sku                 = var.ptp_vpn_sku

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.virtual_network_gateway_public_ip[count.index].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet[count.index].id
  }

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_virtual_network_gateway_connection" "onpremise" {
  count                      = "${var.enable_p2p_vpn == true ? 1 : 0}"
  depends_on                 = [azurerm_virtual_network_gateway.virtual_network_gateway]
  name                       = "Hub-to-OnPrem"
  location                   = var.region
  resource_group_name        = var.resource_group_name
  type                       = "IPsec"
  connection_protocol        = "IKEv2"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.virtual_network_gateway[count.index].id
  local_network_gateway_id   = azurerm_local_network_gateway.ptp_vpn_local_gw[count.index].id
  shared_key                 = var.ptp_vpn_psk

  ipsec_policy {
   ike_encryption   = var.ptp_vpn_ike_encryption
   ike_integrity    = var.ptp_vpn_ike_integrity
   dh_group         = var.ptp_vpn_dh_group
   ipsec_encryption = var.ptp_vpn_ipsec_encryption
   ipsec_integrity  = var.ptp_vpn_ipsec_integrity
   pfs_group        = var.ptp_vpn_pfs_group
   sa_lifetime      = var.ptp_vpn_sa_lifetime
  }

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_route" "vpn_route" {
  count               = "${var.enable_p2p_vpn == true ? 1 : 0}"
  depends_on          = [azurerm_virtual_network_gateway.virtual_network_gateway]
  name                = "VPNRoute"
  resource_group_name = var.resource_group_name
  route_table_name    = azurerm_route_table.vnet_route_table.name
  address_prefix      = var.ptp_vpn_remote_network
  next_hop_type       = "VirtualNetworkGateway"
}

resource "azurerm_route" "firewall_route" {
  count                  = "${var.enable_subnet_firewall == true ? 1 : 0}"
  depends_on             = [azurerm_firewall.vnet_firewall]
  name                   = "FirewallRoute"
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.vnet_route_table.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.vnet_firewall[count.index].ip_configuration[0].private_ip_address
}
