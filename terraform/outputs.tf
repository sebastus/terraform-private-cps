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

# VNet Peering outputs
output "vnet_peering_status" {
  description = "Status and details of VNet peering with vnet-tf-private-box-vkvhvw"
  value       = module.networking.vnet_peering_status
}

output "vnet_peering_local_to_remote_id" {
  description = "ID of the VNet peering from local VNet to vnet-tf-private-box-vkvhvw"
  value       = module.networking.vnet_peering_local_to_remote_id
}

output "vnet_peering_remote_to_local_id" {
  description = "ID of the VNet peering from vnet-tf-private-box-vkvhvw to local VNet"
  value       = module.networking.vnet_peering_remote_to_local_id
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

output "key_vault_private_endpoint_id" {
  description = "ID of the Key Vault private endpoint"
  value       = module.keyvault.private_endpoint_id
}

output "key_vault_private_endpoint_ip" {
  description = "Private IP address of the Key Vault private endpoint"
  value       = module.keyvault.private_endpoint_ip_address
}

output "key_vault_private_endpoint_network_interface" {
  description = "Network interface ID of the Key Vault private endpoint"
  value       = module.keyvault.private_endpoint_network_interface_id
}

# Registry Customer Managed Key outputs
output "registry_customer_managed_key_id" {
  description = "ID of the registry customer-managed encryption key"
  value       = module.keyvault.registry_customer_managed_key_id
}

output "registry_customer_managed_key_version_less_id" {
  description = "Version-less ID of the registry customer-managed encryption key (for container registry encryption)"
  value       = module.keyvault.registry_customer_managed_key_version_less_id
}

output "storage_customer_managed_key_id" {
  description = "ID of the storage customer-managed encryption key"
  value       = module.keyvault.storage_customer_managed_key_id
}

output "storage_customer_managed_key_version_less_id" {
  description = "Version-less ID of the storage customer-managed encryption key"
  value       = module.keyvault.storage_customer_managed_key_version_less_id
}

# User Assigned Managed Identity outputs
output "user_assigned_identity_id" {
  description = "ID of the user-assigned managed identity for Key Vault access"
  value       = module.identity.user_assigned_identity_id
}

output "user_assigned_identity_principal_id" {
  description = "Principal ID of the user-assigned managed identity"
  value       = module.identity.user_assigned_identity_principal_id
}