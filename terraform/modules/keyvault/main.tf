# Azure Key Vault Module
# This module creates a Key Vault with RBAC-based permissions for secrets and keys

# Data source to get current Azure client configuration
data "azurerm_client_config" "current" {}

# Random string for unique resource naming
resource "random_string" "keyvault_suffix" {
  length  = 4
  special = false
  upper   = false
  numeric = true
  
  lifecycle {
    ignore_changes = [keepers]
  }
}

# Local values for consistent tagging and naming
locals {
  common_tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "terraform"
    Purpose     = "key-vault"
  })
  
  # Key Vault name must be globally unique and follow naming restrictions
  keyvault_name = "kv-${var.project_name}-${var.environment}-${random_string.keyvault_suffix.result}"
}

# Azure Key Vault
resource "azurerm_key_vault" "main" {
  name                = local.keyvault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.sku_name

  # Security settings
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_template_deployment = var.enabled_for_template_deployment
  purge_protection_enabled        = var.purge_protection_enabled
  soft_delete_retention_days      = var.soft_delete_retention_days

  # Enable RBAC for Key Vault access (updated syntax for azurerm 4.0+)
  rbac_authorization_enabled = true

  # Network access rules
  network_acls {
    default_action = var.network_access_default_action
    bypass         = "AzureServices"
    
    # Virtual network rules
    virtual_network_subnet_ids = var.allowed_subnet_ids
    
    # IP rules
    ip_rules = var.allowed_ip_ranges
  }

  tags = local.common_tags
  
  lifecycle {
    ignore_changes = [tags]
  }
}

# RBAC Role Assignment: Key Vault Administrator for admin user
# This role provides full access to manage all Key Vault resources
resource "azurerm_role_assignment" "admin_keyvault_administrator" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.admin_user_object_id
}

# RBAC Role Assignment: Key Vault Secrets Officer for admin user
# Additional role for comprehensive secrets management
resource "azurerm_role_assignment" "admin_secrets_officer" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = var.admin_user_object_id
}

# RBAC Role Assignment: Key Vault Crypto Officer for admin user
# Additional role for comprehensive key and cryptographic operations management
resource "azurerm_role_assignment" "admin_crypto_officer" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = var.admin_user_object_id
}

# Private Endpoint for Key Vault
resource "azurerm_private_endpoint" "keyvault" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "pe-${local.keyvault_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-${local.keyvault_name}"
    private_connection_resource_id = azurerm_key_vault.main.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = "pdz-group-keyvault"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }

  tags = local.common_tags
  
  lifecycle {
    ignore_changes = [tags]
  }
}

# Moved blocks to handle resource renaming
moved {
  from = azurerm_key_vault_key.customer_managed_key
  to   = azurerm_key_vault_key.registry_customer_managed_key
}

# Registry Customer Managed Encryption Key
resource "azurerm_key_vault_key" "registry_customer_managed_key" {
  count        = var.create_customer_managed_key ? 1 : 0
  name         = var.cmk_key_name
  key_vault_id = azurerm_key_vault.main.id
  key_type     = var.cmk_key_type
  key_size     = var.cmk_key_size
  key_opts     = var.cmk_key_opts

  # Ensure the key depends on the RBAC role assignments
  depends_on = [
    azurerm_role_assignment.admin_keyvault_administrator,
    azurerm_role_assignment.admin_crypto_officer
  ]

  tags = merge(local.common_tags, {
    Purpose = "registry-encryption"
  })
  
  lifecycle {
    ignore_changes = [tags]
  }
}

# Storage Customer Managed Encryption Key
resource "azurerm_key_vault_key" "storage_customer_managed_key" {
  count        = var.create_storage_cmk ? 1 : 0
  name         = var.storage_cmk_key_name
  key_vault_id = azurerm_key_vault.main.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "unwrapKey", "wrapKey"]

  # Ensure the key depends on the RBAC role assignments
  depends_on = [
    azurerm_role_assignment.admin_keyvault_administrator,
    azurerm_role_assignment.admin_crypto_officer
  ]

  tags = merge(local.common_tags, {
    Purpose = "storage-encryption"
  })
  
  lifecycle {
    ignore_changes = [tags]
  }
}

# Optional: Diagnostic settings for monitoring (requires Log Analytics workspace)
# Uncomment and configure if you have a Log Analytics workspace
# resource "azurerm_monitor_diagnostic_setting" "keyvault" {
#   name               = "keyvault-diagnostics"
#   target_resource_id = azurerm_key_vault.main.id
#   log_analytics_workspace_id = var.log_analytics_workspace_id
#
#   enabled_log {
#     category = "AuditEvent"
#   }
#
#   enabled_log {
#     category = "AzurePolicyEvaluationDetails"
#   }
#
#   metric {
#     category = "AllMetrics"
#     enabled  = true
#   }
# }