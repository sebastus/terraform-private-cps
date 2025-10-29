# Output values for Identity module

output "user_assigned_identity_id" {
  description = "ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.keyvault_access.id
}

output "user_assigned_identity_principal_id" {
  description = "Principal ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.keyvault_access.principal_id
}

output "user_assigned_identity_client_id" {
  description = "Client ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.keyvault_access.client_id
}

output "user_assigned_identity_name" {
  description = "Name of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.keyvault_access.name
}

output "keyvault_crypto_user_role_assignment" {
  description = "Key Vault Crypto Service Encryption User role assignment"
  value       = azurerm_role_assignment.keyvault_crypto_user
}