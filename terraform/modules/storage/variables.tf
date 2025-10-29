# Variables for the Storage module

variable "location" {
  description = "The Azure location where storage resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group for the storage account"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
}

variable "admin_user_object_id" {
  description = "Object ID of the admin user who will have super user abilities in the storage account"
  type        = string
  
  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.admin_user_object_id))
    error_message = "Admin user object ID must be a valid GUID format."
  }
}

variable "subnet_id" {
  description = "ID of the subnet where the private endpoint will be created"
  type        = string
}

variable "private_dns_zone_ids" {
  description = "Private DNS zone IDs for storage services (provided by privatedns module)"
  type = object({
    blob = string
    file = string
  })
}

variable "account_tier" {
  description = "Storage account tier (Standard or Premium)"
  type        = string
  default     = "Standard"
  
  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "Account tier must be either 'Standard' or 'Premium'."
  }
}

variable "account_replication_type" {
  description = "Storage account replication type"
  type        = string
  default     = "LRS"
  
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.account_replication_type)
    error_message = "Replication type must be one of: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  }
}

variable "access_tier" {
  description = "Access tier for blob storage (Hot or Cool)"
  type        = string
  default     = "Hot"
  
  validation {
    condition     = contains(["Hot", "Cool"], var.access_tier)
    error_message = "Access tier must be either 'Hot' or 'Cool'."
  }
}

variable "enable_https_traffic_only" {
  description = "Forces HTTPS if enabled"
  type        = bool
  default     = true
}

variable "min_tls_version" {
  description = "Minimum TLS version for the storage account"
  type        = string
  default     = "TLS1_2"
  
  validation {
    condition     = contains(["TLS1_0", "TLS1_1", "TLS1_2"], var.min_tls_version)
    error_message = "TLS version must be one of: TLS1_0, TLS1_1, TLS1_2."
  }
}

variable "public_network_access_enabled" {
  description = "Whether to allow public network access to the storage account"
  type        = bool
  default     = true
}

variable "network_rules_default_action" {
  description = "Default action for storage account network rules when public access is enabled"
  type        = string
  default     = "Allow"
  
  validation {
    condition     = contains(["Allow", "Deny"], var.network_rules_default_action)
    error_message = "Network rules default action must be either 'Allow' or 'Deny'."
  }
}

variable "allowed_subnet_ids" {
  description = "List of subnet IDs that are allowed to access the storage account"
  type        = list(string)
  default     = []
}

variable "allowed_ip_ranges" {
  description = "List of IP ranges in CIDR format that are allowed to access the storage account"
  type        = list(string)
  default     = []
}

variable "enable_versioning" {
  description = "Enable blob versioning"
  type        = bool
  default     = true
}

variable "enable_change_feed" {
  description = "Enable blob change feed"
  type        = bool
  default     = false
}

variable "delete_retention_days" {
  description = "Number of days to retain deleted blobs"
  type        = number
  default     = 7
  
  validation {
    condition     = var.delete_retention_days >= 1 && var.delete_retention_days <= 365
    error_message = "Delete retention days must be between 1 and 365."
  }
}

variable "container_delete_retention_days" {
  description = "Number of days to retain deleted containers"
  type        = number
  default     = 7
  
  validation {
    condition     = var.container_delete_retention_days >= 1 && var.container_delete_retention_days <= 365
    error_message = "Container delete retention days must be between 1 and 365."
  }
}

variable "share_retention_days" {
  description = "Number of days to retain deleted file shares"
  type        = number
  default     = 7
  
  validation {
    condition     = var.share_retention_days >= 1 && var.share_retention_days <= 365
    error_message = "Share retention days must be between 1 and 365."
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# Customer Managed Encryption Configuration
variable "enable_customer_managed_key" {
  description = "Whether to enable customer-managed encryption for the storage account"
  type        = bool
  default     = false
}

variable "customer_managed_key_id" {
  description = "The version-less ID of the customer-managed key from Key Vault"
  type        = string
  default     = ""
}

variable "key_vault_id" {
  description = "The ID of the Key Vault containing the customer-managed key"
  type        = string
  default     = ""
}

variable "user_assigned_identity_id" {
  description = "The ID of the user-assigned managed identity for accessing the Key Vault"
  type        = string
  default     = ""
}

variable "keyvault_role_assignment" {
  description = "The Key Vault role assignment resource to ensure proper dependencies"
  type        = any
  default     = null
}