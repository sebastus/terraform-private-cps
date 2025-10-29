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