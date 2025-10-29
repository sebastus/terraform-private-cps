# Azure Virtual Network and Subnet Configuration Module
# This module creates a VNet with customizable subnets

# Data source to get current Azure client configuration
data "azurerm_client_config" "current" {}

# Random string for unique resource naming
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
  
  lifecycle {
    ignore_changes = [keepers]
  }
}

# Local values for consistent tagging and naming
locals {
  common_tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "terraform"
  })
  
  resource_suffix = random_string.suffix.result
}

# Resource Group for networking resources
resource "azurerm_resource_group" "networking" {
  name     = "rg-${var.project_name}-networking-${local.resource_suffix}"
  location = var.location

  tags = merge(local.common_tags, {
    Purpose = "networking"
  })
  
  lifecycle {
    ignore_changes = [tags]
  }
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.project_name}-${local.resource_suffix}"
  location            = azurerm_resource_group.networking.location
  resource_group_name = azurerm_resource_group.networking.name
  address_space       = var.vnet_address_space

  tags = merge(local.common_tags, {
    Purpose      = "main-vnet"
    AddressSpace = join(",", var.vnet_address_space)
  })
  
  lifecycle {
    ignore_changes = [tags]
  }
}

# Subnet 1
resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.subnet_address_prefixes.subnet1

  # Service endpoints for secure access to Azure services
  service_endpoints = [
    "Microsoft.KeyVault",
    "Microsoft.Storage"
  ]

  private_endpoint_network_policies = "Disabled"
}

# Subnet 2
resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.subnet_address_prefixes.subnet2

  # Service endpoints for secure access to Azure services
  service_endpoints = [
    "Microsoft.KeyVault",
    "Microsoft.Storage"
  ]

  private_endpoint_network_policies = "Disabled"
}

# Subnet 3
resource "azurerm_subnet" "subnet3" {
  name                 = "subnet3"
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.subnet_address_prefixes.subnet3

  # Service endpoints for secure access to Azure services
  service_endpoints = [
    "Microsoft.KeyVault",
    "Microsoft.Storage"
  ]

  private_endpoint_network_policies = "Disabled"
}

# Subnet 4
resource "azurerm_subnet" "subnet4" {
  name                 = "subnet4"
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.subnet_address_prefixes.subnet4

  # Service endpoints for secure access to Azure services
  service_endpoints = [
    "Microsoft.KeyVault",
    "Microsoft.Storage"
  ]

  private_endpoint_network_policies = "Disabled"
}

# Network Security Groups for each subnet
resource "azurerm_network_security_group" "subnet_nsg" {
  for_each = {
    subnet1 = "subnet1"
    subnet2 = "subnet2"
    subnet3 = "subnet3"
    subnet4 = "subnet4"
  }

  name                = "nsg-${each.value}-${local.resource_suffix}"
  location            = azurerm_resource_group.networking.location
  resource_group_name = azurerm_resource_group.networking.name

  # Allow HTTPS traffic
  security_rule {
    name                       = "allow-https"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow SSH traffic
  security_rule {
    name                       = "allow-ssh"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = merge(local.common_tags, {
    Purpose = "${each.value}-security"
  })
  
  lifecycle {
    ignore_changes = [tags]
  }
}

# Associate NSGs with their respective subnets
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  for_each = {
    subnet1 = azurerm_subnet.subnet1.id
    subnet2 = azurerm_subnet.subnet2.id
    subnet3 = azurerm_subnet.subnet3.id
    subnet4 = azurerm_subnet.subnet4.id
  }

  subnet_id                 = each.value
  network_security_group_id = azurerm_network_security_group.subnet_nsg[each.key].id
}

# VNet Peering Configuration
# Data source to get remote VNet information
data "azurerm_virtual_network" "remote" {
  count               = var.enable_vnet_peering ? 1 : 0
  name                = var.remote_vnet_name
  resource_group_name = split("/", var.remote_vnet_id)[4]  # Extract resource group from resource ID
}

# VNet Peering from local VNet to remote VNet
resource "azurerm_virtual_network_peering" "local_to_remote" {
  count                        = var.enable_vnet_peering ? 1 : 0
  name                         = "peer-${azurerm_virtual_network.main.name}-to-${var.remote_vnet_name}"
  resource_group_name          = azurerm_resource_group.networking.name
  virtual_network_name         = azurerm_virtual_network.main.name
  remote_virtual_network_id    = var.remote_vnet_id
  
  # Peering settings
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

# VNet Peering from remote VNet to local VNet (reciprocal peering)
resource "azurerm_virtual_network_peering" "remote_to_local" {
  count                        = var.enable_vnet_peering ? 1 : 0
  name                         = "peer-${var.remote_vnet_name}-to-${azurerm_virtual_network.main.name}"
  resource_group_name          = data.azurerm_virtual_network.remote[0].resource_group_name
  virtual_network_name         = var.remote_vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.main.id
  
  # Peering settings
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}