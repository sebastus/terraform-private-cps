# Output values for networking module

output "resource_group_name" {
  description = "Name of the networking resource group"
  value       = azurerm_resource_group.networking.name
}

output "resource_group_location" {
  description = "Location of the networking resource group"
  value       = azurerm_resource_group.networking.location
}

output "resource_group_id" {
  description = "ID of the networking resource group"
  value       = azurerm_resource_group.networking.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_address_space" {
  description = "Address space of the virtual network"
  value       = azurerm_virtual_network.main.address_space
}

output "subnet_ids" {
  description = "IDs of all subnets"
  value = {
    subnet1 = azurerm_subnet.subnet1.id
    subnet2 = azurerm_subnet.subnet2.id
    subnet3 = azurerm_subnet.subnet3.id
    subnet4 = azurerm_subnet.subnet4.id
  }
}

output "subnet_address_prefixes" {
  description = "Address prefixes of all subnets"
  value = {
    subnet1 = azurerm_subnet.subnet1.address_prefixes
    subnet2 = azurerm_subnet.subnet2.address_prefixes
    subnet3 = azurerm_subnet.subnet3.address_prefixes
    subnet4 = azurerm_subnet.subnet4.address_prefixes
  }
}

output "network_security_group_ids" {
  description = "Network Security Group IDs"
  value = {
    subnet1 = azurerm_network_security_group.subnet_nsg["subnet1"].id
    subnet2 = azurerm_network_security_group.subnet_nsg["subnet2"].id
    subnet3 = azurerm_network_security_group.subnet_nsg["subnet3"].id
    subnet4 = azurerm_network_security_group.subnet_nsg["subnet4"].id
  }
}

# VNet Peering outputs
output "vnet_peering_local_to_remote_id" {
  description = "ID of the VNet peering from local to remote VNet"
  value       = var.enable_vnet_peering ? azurerm_virtual_network_peering.local_to_remote[0].id : null
}

output "vnet_peering_remote_to_local_id" {
  description = "ID of the VNet peering from remote to local VNet"
  value       = var.enable_vnet_peering ? azurerm_virtual_network_peering.remote_to_local[0].id : null
}

output "vnet_peering_status" {
  description = "Status of VNet peering"
  value = {
    enabled                    = var.enable_vnet_peering
    local_to_remote_id         = var.enable_vnet_peering ? azurerm_virtual_network_peering.local_to_remote[0].id : null
    remote_to_local_id         = var.enable_vnet_peering ? azurerm_virtual_network_peering.remote_to_local[0].id : null
    remote_vnet_name          = var.remote_vnet_name
  }
}