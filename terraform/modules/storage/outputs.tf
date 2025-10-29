# Storage Module Outputs
# This file defines outputs that other modules or root configuration can use

# Storage Account outputs
output "storage_account_id" {
  description = "The ID of the storage account"
  value       = azurerm_storage_account.main.id
}

output "storage_account_name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.main.name
}

output "storage_account_primary_location" {
  description = "The primary location of the storage account"
  value       = azurerm_storage_account.main.primary_location
}

output "storage_account_secondary_location" {
  description = "The secondary location of the storage account"
  value       = azurerm_storage_account.main.secondary_location
}

# Primary endpoints
output "primary_blob_endpoint" {
  description = "The endpoint URL for blob storage in the primary location"
  value       = azurerm_storage_account.main.primary_blob_endpoint
}

output "primary_file_endpoint" {
  description = "The endpoint URL for file storage in the primary location"
  value       = azurerm_storage_account.main.primary_file_endpoint
}

output "primary_web_endpoint" {
  description = "The endpoint URL for web storage in the primary location"
  value       = azurerm_storage_account.main.primary_web_endpoint
}

# Private endpoints
output "blob_private_endpoint_id" {
  description = "The ID of the blob storage private endpoint"
  value       = azurerm_private_endpoint.blob.id
}

output "file_private_endpoint_id" {
  description = "The ID of the file storage private endpoint"
  value       = azurerm_private_endpoint.file.id
}

output "blob_private_endpoint_fqdn" {
  description = "The private FQDN for blob storage"
  value       = azurerm_private_endpoint.blob.private_service_connection[0].private_ip_address
}

output "file_private_endpoint_fqdn" {
  description = "The private FQDN for file storage"
  value       = azurerm_private_endpoint.file.private_service_connection[0].private_ip_address
}

# Private DNS Zone outputs (passed through from privatedns module)
output "blob_private_dns_zone_id" {
  description = "The ID of the blob storage private DNS zone (from privatedns module)"
  value       = var.private_dns_zone_ids.blob
}

output "file_private_dns_zone_id" {
  description = "The ID of the file storage private DNS zone (from privatedns module)"
  value       = var.private_dns_zone_ids.file
}

# Role assignment outputs
output "admin_storage_account_contributor_assignment_id" {
  description = "The ID of the Storage Account Contributor role assignment"
  value       = azurerm_role_assignment.admin_storage_account_contributor.id
}

output "admin_blob_data_owner_assignment_id" {
  description = "The ID of the Storage Blob Data Owner role assignment"
  value       = azurerm_role_assignment.admin_blob_data_owner.id
}

output "admin_file_data_contributor_assignment_id" {
  description = "The ID of the Storage File Data SMB Share Contributor role assignment"
  value       = azurerm_role_assignment.admin_file_data_contributor.id
}

# Random suffix for reference
output "storage_suffix" {
  description = "The random suffix used in the storage account name"
  value       = random_string.storage_suffix.result
}

# Connection information (useful for applications)
output "connection_info" {
  description = "Connection information for the storage account"
  value = {
    storage_account_name = azurerm_storage_account.main.name
    storage_account_id   = azurerm_storage_account.main.id
    blob_endpoint        = azurerm_storage_account.main.primary_blob_endpoint
    file_endpoint        = azurerm_storage_account.main.primary_file_endpoint
    access_tier          = azurerm_storage_account.main.access_tier
    replication_type     = azurerm_storage_account.main.account_replication_type
  }
  sensitive = false
}