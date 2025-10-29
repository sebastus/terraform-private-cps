# Private DNS Zones Module
# This module creates Azure Private DNS zones for various Azure services

# Local values for DNS zone names
locals {
  # Private DNS zone names for Azure services
  dns_zones = {
    # Storage services
    blob                = "privatelink.blob.core.windows.net"
    file                = "privatelink.file.core.windows.net"
    queue               = "privatelink.queue.core.windows.net"
    table               = "privatelink.table.core.windows.net"
    web                 = "privatelink.web.core.windows.net"
    dfs                 = "privatelink.dfs.core.windows.net"
    
    # Database services
    sql_server          = "privatelink.database.windows.net"
    mysql               = "privatelink.mysql.database.azure.com"
    postgres            = "privatelink.postgres.database.azure.com"
    cosmos_sql          = "privatelink.documents.azure.com"
    cosmos_mongo        = "privatelink.mongo.cosmos.azure.com"
    cosmos_cassandra    = "privatelink.cassandra.cosmos.azure.com"
    cosmos_gremlin      = "privatelink.gremlin.cosmos.azure.com"
    cosmos_table        = "privatelink.table.cosmos.azure.com"
    redis               = "privatelink.redis.cache.windows.net"
    
    # Key Vault
    key_vault           = "privatelink.vaultcore.azure.net"
    
    # Container services
    container_registry  = "privatelink.azurecr.io"
    
    # App services
    app_service         = "privatelink.azurewebsites.net"
    
    # AI/Cognitive services
    cognitive_services  = "privatelink.cognitiveservices.azure.com"
    openai              = "privatelink.openai.azure.com"
    
    # Event services
    event_hub           = "privatelink.servicebus.windows.net"
    event_grid          = "privatelink.eventgrid.azure.net"
    service_bus         = "privatelink.servicebus.windows.net"
    
    # Monitoring and analytics
    monitor             = "privatelink.monitor.azure.com"
    log_analytics       = "privatelink.oms.opinsights.azure.com"
    
    # Other services
    search              = "privatelink.search.windows.net"
    signalr             = "privatelink.service.signalr.net"
    iot_hub             = "privatelink.azure-devices.net"
    media_services      = "privatelink.media.azure.net"
    backup              = "privatelink.backup.windowsazure.com"
    automation          = "privatelink.azure-automation.net"
  }
  
  # Get enabled zones
  enabled_zones = {
    for key, enabled in var.enable_zones : key => local.dns_zones[key]
    if enabled == true
  }
  
  common_tags = merge(var.tags, {
    ManagedBy = "terraform"
    Purpose   = "private-dns"
  })
}

# Create private DNS zones for enabled services
resource "azurerm_private_dns_zone" "zones" {
  for_each = local.enabled_zones
  
  name                = each.value
  resource_group_name = var.resource_group_name

  tags = local.common_tags
  
  lifecycle {
    ignore_changes = [tags]
  }
}

# Create virtual network links for each enabled zone
resource "azurerm_private_dns_zone_virtual_network_link" "links" {
  for_each = {
    for link in flatten([
      for zone_key, zone_name in local.enabled_zones : [
        for vnet in var.virtual_network_links : {
          zone_key    = zone_key
          zone_name   = zone_name
          vnet_name   = vnet.name
          vnet_id     = vnet.virtual_network_id
          registration = vnet.registration_enabled
          link_key    = "${zone_key}-${vnet.name}"
        }
      ]
    ]) : link.link_key => link
  }
  
  name                  = "vnet-link-${each.value.vnet_name}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.zones[each.value.zone_key].name
  virtual_network_id    = each.value.vnet_id
  registration_enabled  = each.value.registration
  
  tags = local.common_tags
  
  lifecycle {
    ignore_changes = [tags]
  }
}