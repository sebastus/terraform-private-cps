# Azure Storage Account Module
# This module creates a StorageV2 account with blob and file services, private endpoints, and RBAC

# Data source to get current Azure client configuration
data "azurerm_client_config" "current" {}

# Random string for unique resource naming
resource "random_string" "storage_suffix" {
  length  = 8
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
    Purpose     = "storage"
  })
  
  # Storage account name must be globally unique and follow naming restrictions
  storage_account_name = "${var.project_name}${var.environment}${random_string.storage_suffix.result}"
}

# Azure Storage Account (StorageV2)
resource "azurerm_storage_account" "main" {
  name                = local.storage_account_name
  resource_group_name = var.resource_group_name
  location            = var.location
  
  # StorageV2 account with specified tier and replication
  account_kind             = "StorageV2"
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  access_tier              = var.access_tier
  
  # Security settings
  https_traffic_only_enabled = var.enable_https_traffic_only
  min_tls_version            = var.min_tls_version
  
  # Network access settings
  public_network_access_enabled = var.public_network_access_enabled
  
  # Enable RBAC for storage access
  shared_access_key_enabled = false
  
  # Network rules (only applied when public access is enabled)
  dynamic "network_rules" {
    for_each = var.public_network_access_enabled ? [1] : []
    content {
      default_action             = var.network_rules_default_action
      bypass                     = ["AzureServices"]
      virtual_network_subnet_ids = var.allowed_subnet_ids
      ip_rules                   = var.allowed_ip_ranges
    }
  }
  
  # Blob properties
  blob_properties {
    versioning_enabled  = var.enable_versioning
    change_feed_enabled = var.enable_change_feed
    
    delete_retention_policy {
      days = var.delete_retention_days
    }
    
    container_delete_retention_policy {
      days = var.container_delete_retention_days
    }
  }
  
  # File share properties
  share_properties {
    retention_policy {
      days = var.share_retention_days
    }
  }

  tags = local.common_tags
  
  lifecycle {
    ignore_changes = [tags]
  }
}

# Private Endpoints for storage services

# Private Endpoint for Blob Storage
resource "azurerm_private_endpoint" "blob" {
  name                = "pe-${local.storage_account_name}-blob"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-${local.storage_account_name}-blob"
    private_connection_resource_id = azurerm_storage_account.main.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "pdz-group-blob"
    private_dns_zone_ids = [var.private_dns_zone_ids.blob]
  }

  tags = local.common_tags
  
  lifecycle {
    ignore_changes = [tags]
  }
}

# Private Endpoint for File Storage
resource "azurerm_private_endpoint" "file" {
  name                = "pe-${local.storage_account_name}-file"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-${local.storage_account_name}-file"
    private_connection_resource_id = azurerm_storage_account.main.id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }

  private_dns_zone_group {
    name                 = "pdz-group-file"
    private_dns_zone_ids = [var.private_dns_zone_ids.file]
  }

  tags = local.common_tags
  
  lifecycle {
    ignore_changes = [tags]
  }
}

# RBAC Role Assignments for admin user

# Storage Account Contributor - Full management access to the storage account
resource "azurerm_role_assignment" "admin_storage_account_contributor" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.admin_user_object_id
}

# Storage Blob Data Owner - Full access to blob data
resource "azurerm_role_assignment" "admin_blob_data_owner" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.admin_user_object_id
}

# Storage File Data SMB Share Contributor - Full access to file share data
resource "azurerm_role_assignment" "admin_file_data_contributor" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage File Data SMB Share Contributor"
  principal_id         = var.admin_user_object_id
}

# Optional: Sample containers and file shares (commented out by default)
# Uncomment and customize as needed for your use case

# resource "azurerm_storage_container" "example" {
#   name                  = "example-container"
#   storage_account_name  = azurerm_storage_account.main.name
#   container_access_type = "private"
# }

# resource "azurerm_storage_share" "example" {
#   name                 = "example-share"
#   storage_account_name = azurerm_storage_account.main.name
#   quota                = 50  # GB
#   access_tier          = "Hot"
# }