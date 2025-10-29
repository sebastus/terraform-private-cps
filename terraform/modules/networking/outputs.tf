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
    bastion = var.enable_bastion ? azurerm_subnet.bastion[0].id : null
  }
}

output "subnet_address_prefixes" {
  description = "Address prefixes of all subnets"
  value = {
    subnet1 = azurerm_subnet.subnet1.address_prefixes
    subnet2 = azurerm_subnet.subnet2.address_prefixes
    subnet3 = azurerm_subnet.subnet3.address_prefixes
    subnet4 = azurerm_subnet.subnet4.address_prefixes
    bastion = var.enable_bastion ? azurerm_subnet.bastion[0].address_prefixes : null
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

output "bastion_public_ip" {
  description = "Public IP address of the Azure Bastion"
  value       = var.enable_bastion ? azurerm_public_ip.bastion[0].ip_address : null
}

output "bastion_host_name" {
  description = "Name of the Azure Bastion host"
  value       = var.enable_bastion ? azurerm_bastion_host.main[0].name : null
}

output "bastion_host_dns_name" {
  description = "DNS name of the Azure Bastion host"
  value       = var.enable_bastion ? azurerm_bastion_host.main[0].dns_name : null
}

output "bastion_host_id" {
  description = "ID of the Azure Bastion host"
  value       = var.enable_bastion ? azurerm_bastion_host.main[0].id : null
}