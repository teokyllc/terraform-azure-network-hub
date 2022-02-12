# terraform-azure-network-hub
Terraform module to build a hub network layer as part of a hub and spoke network model.  This network layout centralizes management and governance into the hub.  Spoke VNET's will connect to this hub via peered connections.

## Module examples
Simple example<br>
<pre>
module "network-hub" {
    source                        = "github.com/teokyllc/terraform-azure-network-hub"
    environment_tag               = "MGMT"
    region                        = "EastUS"
    hub_rg_name                   = "Hub-RG"
    hub_vnet_name                 = "Hub-vNet"
    hub_route_table_name          = "Hub-Route-Table"
    default_subnet_name           = "default"
    enable_p2p_vpn                = false
    enable_subnet_nsg             = false
    enable_subnet_firewall        = false
    disable_bgp_route_propagation = false
    vnet_cidr                     = "10.0.0.0/16"
    default_subnet_cidr           = "10.0.0.0/24"
    firewall_subnet_cidr          = "10.0.254.0/24"
    gateway_subnet_cidr           = "10.0.255.0/24"
}
</pre><br><br>

With Point to Point VPN<br>
<pre>
module "network-hub" {
    source                        = "github.com/teokyllc/terraform-azure-network-hub"
    environment_tag               = "MGMT"
    region                        = "EastUS"
    hub_rg_name                   = "Hub-RG"
    hub_vnet_name                 = "Hub-vNet"
    hub_route_table_name          = "Hub-Route-Table"
    default_subnet_name           = "default"
    enable_p2p_vpn                = false
    enable_subnet_nsg             = false
    enable_subnet_firewall        = false
    disable_bgp_route_propagation = false
    vnet_cidr                     = "10.0.0.0/16"
    default_subnet_cidr           = "10.0.0.0/24"
    firewall_subnet_cidr          = "10.0.254.0/24"
    gateway_subnet_cidr           = "10.0.255.0/24"
    vgw_active_active_mode        = false
    ptp_vpn_enable_bgp            = false
    ptp_vpn_sku                   = "VpnGw1"
    ptp_vpn_psk                   = "password"
    ptp_vpn_remote_endpoint_name  = "on-prem"
    ptp_vpn_remote_endpoint_fqdn  = "router.example.com"
    ptp_vpn_remote_network        = "192.168.0.0/24"
    ptp_vpn_ike_encryption        = "AES256"
    ptp_vpn_ike_integrity         = "SHA256"
    ptp_vpn_dh_group              = "DHGroup2"
    ptp_vpn_ipsec_encryption      = "GCMAES256"
    ptp_vpn_ipsec_integrity       = "GCMAES256"
    ptp_vpn_pfs_group             = "PFS2"
    ptp_vpn_sa_lifetime           = "3600"
}
</pre><br><br>