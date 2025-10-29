# Private DNS Module Outputs
# This file defines outputs for private DNS zones and their configurations

# Output all created private DNS zone IDs
output "zone_ids" {
  description = "Map of private DNS zone IDs by service type"
  value = {
    for key, zone in azurerm_private_dns_zone.zones : key => zone.id
  }
}

# Output all created private DNS zone names
output "zone_names" {
  description = "Map of private DNS zone names by service type"
  value = {
    for key, zone in azurerm_private_dns_zone.zones : key => zone.name
  }
}

# Individual zone outputs for commonly used services
output "blob_zone_id" {
  description = "Private DNS zone ID for blob storage"
  value       = try(azurerm_private_dns_zone.zones["blob"].id, null)
}

output "file_zone_id" {
  description = "Private DNS zone ID for file storage"
  value       = try(azurerm_private_dns_zone.zones["file"].id, null)
}

output "key_vault_zone_id" {
  description = "Private DNS zone ID for Key Vault"
  value       = try(azurerm_private_dns_zone.zones["key_vault"].id, null)
}

output "sql_server_zone_id" {
  description = "Private DNS zone ID for SQL Server"
  value       = try(azurerm_private_dns_zone.zones["sql_server"].id, null)
}

output "container_registry_zone_id" {
  description = "Private DNS zone ID for Container Registry"
  value       = try(azurerm_private_dns_zone.zones["container_registry"].id, null)
}

output "app_service_zone_id" {
  description = "Private DNS zone ID for App Service"
  value       = try(azurerm_private_dns_zone.zones["app_service"].id, null)
}

# Virtual network link outputs
output "virtual_network_links" {
  description = "Map of virtual network link IDs"
  value = {
    for key, link in azurerm_private_dns_zone_virtual_network_link.links : key => link.id
  }
}

# Convenient output for storage services
output "storage_zones" {
  description = "Private DNS zone IDs for storage services"
  value = {
    blob  = try(azurerm_private_dns_zone.zones["blob"].id, null)
    file  = try(azurerm_private_dns_zone.zones["file"].id, null)
    queue = try(azurerm_private_dns_zone.zones["queue"].id, null)
    table = try(azurerm_private_dns_zone.zones["table"].id, null)
    web   = try(azurerm_private_dns_zone.zones["web"].id, null)
    dfs   = try(azurerm_private_dns_zone.zones["dfs"].id, null)
  }
}

# Convenient output for database services
output "database_zones" {
  description = "Private DNS zone IDs for database services"
  value = {
    sql_server       = try(azurerm_private_dns_zone.zones["sql_server"].id, null)
    mysql            = try(azurerm_private_dns_zone.zones["mysql"].id, null)
    postgres         = try(azurerm_private_dns_zone.zones["postgres"].id, null)
    cosmos_sql       = try(azurerm_private_dns_zone.zones["cosmos_sql"].id, null)
    cosmos_mongo     = try(azurerm_private_dns_zone.zones["cosmos_mongo"].id, null)
    cosmos_cassandra = try(azurerm_private_dns_zone.zones["cosmos_cassandra"].id, null)
    cosmos_gremlin   = try(azurerm_private_dns_zone.zones["cosmos_gremlin"].id, null)
    cosmos_table     = try(azurerm_private_dns_zone.zones["cosmos_table"].id, null)
    redis            = try(azurerm_private_dns_zone.zones["redis"].id, null)
  }
}