# Azure User Assigned Managed Identity Module
# This module creates a user-assigned managed identity for accessing Key Vault resources

# Local values for consistent tagging and naming
locals {
  common_tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "terraform"
    Purpose     = "key-vault-access"
  })
}

# User Assigned Managed Identity
resource "azurerm_user_assigned_identity" "keyvault_access" {
  name                = "uami-${var.project_name}-keyvault-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = local.common_tags
  
  lifecycle {
    ignore_changes = [tags]
  }
}

# Role Assignment: Key Vault Crypto Service Encryption User
# This role allows the identity to use keys for encryption/decryption
resource "azurerm_role_assignment" "keyvault_crypto_user" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_user_assigned_identity.keyvault_access.principal_id
}