# Output values for Key Vault module

output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "key_vault_resource_group_name" {
  description = "Resource group name of the Key Vault"
  value       = azurerm_key_vault.main.resource_group_name
}

output "key_vault_location" {
  description = "Location of the Key Vault"
  value       = azurerm_key_vault.main.location
}

output "key_vault_tenant_id" {
  description = "Tenant ID of the Key Vault"
  value       = azurerm_key_vault.main.tenant_id
}

output "key_vault_sku_name" {
  description = "SKU name of the Key Vault"
  value       = azurerm_key_vault.main.sku_name
}

output "admin_role_assignments" {
  description = "Role assignments for the admin user"
  value = {
    administrator  = azurerm_role_assignment.admin_keyvault_administrator.id
    secrets_officer = azurerm_role_assignment.admin_secrets_officer.id
    crypto_officer  = azurerm_role_assignment.admin_crypto_officer.id
  }
}

output "key_vault_access_url" {
  description = "URL to access the Key Vault in Azure Portal"
  value       = "https://portal.azure.com/#@${data.azurerm_client_config.current.tenant_id}/resource${azurerm_key_vault.main.id}"
}

output "private_endpoint_id" {
  description = "ID of the Key Vault private endpoint"
  value       = var.enable_private_endpoint ? azurerm_private_endpoint.keyvault[0].id : null
}

output "private_endpoint_ip_address" {
  description = "Private IP address of the Key Vault private endpoint"
  value       = var.enable_private_endpoint ? azurerm_private_endpoint.keyvault[0].private_service_connection[0].private_ip_address : null
}

output "private_endpoint_network_interface_id" {
  description = "Network interface ID of the Key Vault private endpoint"
  value       = var.enable_private_endpoint ? azurerm_private_endpoint.keyvault[0].network_interface[0].id : null
}

# Registry Customer Managed Key outputs
output "registry_customer_managed_key_id" {
  description = "ID of the registry customer-managed encryption key"
  value       = var.create_customer_managed_key ? azurerm_key_vault_key.registry_customer_managed_key[0].id : null
}

output "registry_customer_managed_key_name" {
  description = "Name of the registry customer-managed encryption key"
  value       = var.create_customer_managed_key ? azurerm_key_vault_key.registry_customer_managed_key[0].name : null
}

output "registry_customer_managed_key_version" {
  description = "Version of the registry customer-managed encryption key"
  value       = var.create_customer_managed_key ? azurerm_key_vault_key.registry_customer_managed_key[0].version : null
}

output "registry_customer_managed_key_version_less_id" {
  description = "Version-less ID of the registry customer-managed encryption key (for use with container registry encryption)"
  value       = var.create_customer_managed_key ? azurerm_key_vault_key.registry_customer_managed_key[0].versionless_id : null
}

# Storage Customer Managed Key outputs
output "storage_customer_managed_key_id" {
  description = "ID of the storage customer-managed encryption key"
  value       = var.create_storage_cmk ? azurerm_key_vault_key.storage_customer_managed_key[0].id : null
}

output "storage_customer_managed_key_version_less_id" {
  description = "Version-less ID of the storage customer-managed encryption key"
  value       = var.create_storage_cmk ? azurerm_key_vault_key.storage_customer_managed_key[0].versionless_id : null
}