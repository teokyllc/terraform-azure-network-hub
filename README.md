# terraform-azure-network-hub
Terraform module to build a hub network layer as part of a hub and spoke network model.  This network layout centralizes management and governance into the hub.  Spoke VNET's will connect to this hub via peered connections.

## Module examples
Simple example<br>
<pre>
module "network-hub" {
    source          = "app.terraform.io/ANET/network-hub/azure"
    version         = "1.0.6"
    environment_tag = "MGMT"
    region          = "EastUS2"
    vnet_cidr       = "10.0.0.0/16"
    gateway_subnet  = "10.0.255.0/24"
}
</pre><br><br>

With Point to Point VPN<br>
<pre>
module "network-hub" {
    source                      = "app.terraform.io/ANET/network-hub/azure"
    version                     = "1.0.6"
    environment_tag = "MGMT"    = "MGMT"
    region                      = "EastUS2"
    vnet_cidr                   = "10.0.0.0/16"
    gateway_subnet              = "10.0.255.0/24"
    enable_ptp_vpn              = true
    virtual_network_gateway_sku = "VpnGw1"
    ptp_vpn_psk                 = "password"
    ptp_vpn_remote_gw_name      = "Home-Office"
    ptp_vpn_remote_endpoint     = "1.1.1.1"
    ptp_vpn_remote_network      = "192.168.0.0/16"
    ptp_vpn_ike_encryption      = "AES256"
    ptp_vpn_ike_integrity       = "SHA256"
    ptp_vpn_dh_group            = "DHGroup2"
    ptp_vpn_ipsec_encryption    = "GCMAES256"
    ptp_vpn_ipsec_integrity     = "GCMAES256"
    ptp_vpn_pfs_group           = "PFS2"
    ptp_vpn_sa_lifetime         = "3600"
}
</pre><br><br>
