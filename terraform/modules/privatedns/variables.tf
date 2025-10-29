# Private DNS Module Variables
# This module creates private DNS zones for Azure services

variable "resource_group_name" {
  description = "Name of the resource group where private DNS zones will be created"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

# Control which private DNS zones to create
variable "enable_zones" {
  description = "Control which private DNS zones to create"
  type = object({
    # Storage services
    blob                = optional(bool, false)
    file                = optional(bool, false)
    queue               = optional(bool, false)
    table               = optional(bool, false)
    web                 = optional(bool, false)
    dfs                 = optional(bool, false)  # Data Lake Storage Gen2
    
    # Database services
    sql_server          = optional(bool, false)
    mysql               = optional(bool, false)
    postgres            = optional(bool, false)
    cosmos_sql          = optional(bool, false)
    cosmos_mongo        = optional(bool, false)
    cosmos_cassandra    = optional(bool, false)
    cosmos_gremlin      = optional(bool, false)
    cosmos_table        = optional(bool, false)
    redis               = optional(bool, false)
    
    # Key Vault
    key_vault           = optional(bool, false)
    
    # Container services
    container_registry  = optional(bool, false)
    
    # App services
    app_service         = optional(bool, false)
    
    # AI/Cognitive services
    cognitive_services  = optional(bool, false)
    openai              = optional(bool, false)
    
    # Event services
    event_hub           = optional(bool, false)
    event_grid          = optional(bool, false)
    service_bus         = optional(bool, false)
    
    # Monitoring and analytics
    monitor             = optional(bool, false)
    log_analytics       = optional(bool, false)
    
    # Other services
    search              = optional(bool, false)
    signalr             = optional(bool, false)
    iot_hub             = optional(bool, false)
    media_services      = optional(bool, false)
    backup              = optional(bool, false)
    automation          = optional(bool, false)
  })
  default = {}
}

# Virtual network configuration for DNS zone links
variable "virtual_network_links" {
  description = "Virtual networks to link to the private DNS zones"
  type = list(object({
    name               = string
    virtual_network_id = string
    registration_enabled = optional(bool, false)
  }))
  default = []
}