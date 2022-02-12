variable "region" {
    type = string
    description = "The Azure region the resources will be deployed to."
}

variable "hub_rg_name" {
    type = string
    description = "The name for the network hub resource group."
}

variable "hub_vnet_name" {
    type = string
    description = "The name for the network hub vNet."
}

variable "default_subnet_name" {
    type = string
    description = "The name for the subnet created within the vNet."
}

variable "enable_p2p_vpn" {
    type = bool
    description = "Enables an IPSec Point to Point VPN."
}

variable "enable_subnet_nsg" {
    type = bool
    description = "Enables a NSG to be attached to the default subnet."
}

variable "enable_subnet_firewall" {
    type = bool
    description = "Enables an Azure Firewall to be attached to the default subnet."
}

variable "hub_route_table_name" {
    type = string
    description = "The name for the network hub route table."
}

variable "disable_bgp_route_propagation" {
    type = bool
    description = "If true, disables BGP route propagation."
}

variable "environment_tag" {
    type = string
    description = "The name for the environment tag."
}

variable "vnet_cidr" {
    type = string
    description = "The CIDR block for the vNet."
}

variable "dns_servers" {
    type = list
    default = null
    description = "A list of DNS servers for the VNET."
}

variable "default_subnet_cidr" {
    type = string
    description = "The CIDR block for the default subnet."
}

variable "gateway_subnet_cidr" {
    type = string
    default = "10.0.255.0/24"
    description = "The CIDR block for the gateway subnet."
}

variable "firewall_subnet_cidr" {
    type = string
    default = "10.0.254.0/24"
    description = "The CIDR block for the firewall subnet."
}

variable "vgw_active_active_mode" {
    type = bool
    default = false
    description = "If true, an active-active Virtual Network Gateway will be created. An active-active gateway requires a HighPerformance or an UltraPerformance sku."
}

variable "ptp_vpn_enable_bgp" {
    type = bool
    default = false
    description = "Enables BGP on VPN Gateway."
}

variable "ptp_vpn_sku" {
    type = string
    default = "VpnGw1"
    description = "Configuration of the size and capacity of the virtual network gateway."
}

variable "ptp_vpn_psk" {
    type = string
    sensitive = true
    default = "secureString"
    description = "The shared IPSec key."
}

variable "ptp_vpn_remote_endpoint_name" {
    type = string
    default = "on-prem"
    description = "A name for the remote VPN endpoint."
}

variable "ptp_vpn_remote_endpoint_fqdn" {
    type = string
    default = "router.example.com"
    description = "The FQDN address of the remote VPN endpoint."
}

variable "ptp_vpn_remote_network" {
    type = string
    default = "192.168.0.0/24"
    description = "The CIDR block of the remote network."
}

variable "ptp_vpn_ike_encryption" {
    type = string
    default = "AES256"
    description = "The IKE encryption algorithm. Valid options are AES128, AES192, AES256, DES, DES3, GCMAES128, or GCMAES256."
}

variable "ptp_vpn_ike_integrity" {
    type = string
    default = "SHA256"
    description = "The IKE integrity algorithm. Valid options are GCMAES128, GCMAES256, MD5, SHA1, SHA256, or SHA384."
}

variable "ptp_vpn_dh_group" {
    type = string
    default = "DHGroup2"
    description = "The DH group used in IKE phase 1 for initial SA. Valid options are DHGroup1, DHGroup14, DHGroup2, DHGroup2048, DHGroup24, ECP256, ECP384, or None."
}

variable "ptp_vpn_ipsec_encryption" {
    type = string
    default = "AES256"
    description = "The IPSec encryption algorithm. Valid options are AES128, AES192, AES256, DES, DES3, GCMAES128, GCMAES192, GCMAES256, or None."
}

variable "ptp_vpn_ipsec_integrity" {
    type = string
    default = "GCMAES256"
    description = "The IPSec integrity algorithm. Valid options are GCMAES128, GCMAES192, GCMAES256, MD5, SHA1, or SHA256."
}

variable "ptp_vpn_pfs_group" {
    type = string
    default = "None"
    description = "The DH group used in IKE phase 2 for new child SA. Valid options are ECP256, ECP384, PFS1, PFS14, PFS2, PFS2048, PFS24, PFSMM, or None."
}

variable "ptp_vpn_sa_lifetime" {
    type = number
    default = 27000
    description = "The IPSec SA lifetime in seconds. Must be at least 300 seconds."
}