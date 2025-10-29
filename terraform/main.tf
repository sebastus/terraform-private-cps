# Main Terraform configuration
# This file orchestrates the deployment of infrastructure components

# Local values for common configuration
locals {
  # Common tags applied to all resources
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    CreatedDate = formatdate("YYYY-MM-DD", timestamp())
  }
}

# Networking Module
module "networking" {
  source = "./modules/networking"

  # Required variables
  location     = var.location
  environment  = var.environment
  project_name = var.project_name

  # Optional variables with defaults
  vnet_address_space = ["10.0.0.0/18"]
  
  subnet_address_prefixes = {
    subnet1 = ["10.0.0.0/27"]
    subnet2 = ["10.0.0.32/27"]
    subnet3 = ["10.0.0.64/27"]
    subnet4 = ["10.0.0.96/27"]
    bastion = ["10.0.0.128/27"]
  }

  enable_bastion = true

  # Apply common tags
  tags = local.common_tags
}

# Private DNS Module
module "privatedns" {
  source = "./modules/privatedns"

  # Required variables
  resource_group_name = module.networking.resource_group_name

  # Enable zones for services we're using
  enable_zones = {
    blob      = true
    file      = true
    key_vault = true
  }

  # Link to our VNet
  virtual_network_links = [
    {
      name               = "vnet-link-main"
      virtual_network_id = module.networking.vnet_id
      registration_enabled = false
    }
  ]

  # Apply common tags
  tags = local.common_tags
}

# Key Vault Module
module "keyvault" {
  source = "./modules/keyvault"

  # Required variables
  location            = var.location
  resource_group_name = module.networking.resource_group_name
  environment         = var.environment
  project_name        = var.project_name
  admin_user_object_id = var.admin_user_object_id

  # Optional variables with security-focused defaults
  sku_name                        = "standard"
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = false
  enabled_for_template_deployment = true
  purge_protection_enabled        = true
  soft_delete_retention_days      = 7
  
  # Network access restrictions (deny by default for security)
  network_access_default_action = "Deny"
  allowed_subnet_ids = [
    module.networking.subnet_ids.subnet1,
    module.networking.subnet_ids.subnet2,
    module.networking.subnet_ids.subnet3,
    module.networking.subnet_ids.subnet4
  ]

  # Apply common tags
  tags = local.common_tags
}

# Storage Module
module "storage" {
  source = "./modules/storage"

  # Required variables
  location            = var.location
  resource_group_name = module.networking.resource_group_name
  environment         = var.environment
  project_name        = var.project_name
  admin_user_object_id = var.admin_user_object_id

  # Network configuration - place in subnet1 with private endpoint
  subnet_id = module.networking.subnet_ids.subnet1
  
  # Private DNS zones from privatedns module
  private_dns_zone_ids = {
    blob = module.privatedns.blob_zone_id
    file = module.privatedns.file_zone_id
  }
  
  # Storage account configuration
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  access_tier              = "Hot"
  
  # Security settings
  enable_https_traffic_only     = true
  min_tls_version              = "TLS1_2"
  public_network_access_enabled = var.storage_public_access_enabled
  
  # Network access rules (when public access is enabled)
  network_rules_default_action = "Deny"
  allowed_subnet_ids = [
    module.networking.subnet_ids.subnet1,
    module.networking.subnet_ids.subnet2,
    module.networking.subnet_ids.subnet3,
    module.networking.subnet_ids.subnet4
  ]
  allowed_ip_ranges = var.storage_allowed_ip_ranges
  
  # Data protection settings
  enable_versioning                   = true
  enable_change_feed                 = false
  delete_retention_days              = 30
  container_delete_retention_days    = 7
  share_retention_days               = 30

  # Apply common tags
  tags = local.common_tags
}