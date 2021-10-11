variable "environment_tag" {
    type = string
    default = "MGMT"
    description = "The type of environment."
}

variable "vnet_cidr" {
    type = string
    default = "10.0.0.0/16"
    description = "The CIDR address for the Azure VNET."
}

variable "dns_servers" {
    default = ["192.168.3.2"]
    description = "A list of DNS servers for the VNET."
}

variable "region" {
    type = string
    default = "EastUS"
    description = "The Azure region the VNET will be placed in."
}

variable "default_subnet" {
    type = string
    default = "10.0.0.0/24"
    description = "The CIDR block for the default subnet."
}

variable "gateway_subnet" {
    type = string
    default = "10.0.255.0/24"
    description = "The CIDR block for the VPN subnet."
}

variable "ptp_vpn_psk" {
    type = string
    sensitive = true
    default = "password"
    description = "The shared IPSec key."
}

variable "ptp_vpn_remote_gw_name" {
    type = string
    default = "home"
    description = "A name for the remote gateway."
}

variable "ptp_vpn_remote_endpoint" {
    type = string
    default = "gate.teokyllc.org"
    description = "The FQDN address of the remote VPN endpoint."
}

variable "ptp_vpn_remote_network" {
    type = string
    default = "192.168.0.0/16"
    description = "The CIDR block of the remote network."
}

