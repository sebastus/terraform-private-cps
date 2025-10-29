# Output values from networking module

output "resource_group_name" {
  description = "Name of the networking resource group"
  value       = module.networking.resource_group_name
}

output "resource_group_location" {
  description = "Location of the networking resource group"
  value       = module.networking.resource_group_location
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = module.networking.vnet_name
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = module.networking.vnet_id
}

output "vnet_address_space" {
  description = "Address space of the virtual network"
  value       = module.networking.vnet_address_space
}

output "subnet_ids" {
  description = "IDs of all subnets"
  value       = module.networking.subnet_ids
}

output "subnet_address_prefixes" {
  description = "Address prefixes of all subnets"
  value       = module.networking.subnet_address_prefixes
}

output "network_security_groups" {
  description = "Network Security Group IDs"
  value       = module.networking.network_security_group_ids
}

output "bastion_public_ip" {
  description = "Public IP address of the Azure Bastion"
  value       = module.networking.bastion_public_ip
}

output "bastion_host_name" {
  description = "Name of the Azure Bastion host"
  value       = module.networking.bastion_host_name
}

output "bastion_host_dns_name" {
  description = "DNS name of the Azure Bastion host"
  value       = module.networking.bastion_host_dns_name
}

# Key Vault outputs
output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = module.keyvault.key_vault_id
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = module.keyvault.key_vault_name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = module.keyvault.key_vault_uri
}

output "key_vault_access_url" {
  description = "URL to access the Key Vault in Azure Portal"
  value       = module.keyvault.key_vault_access_url
}