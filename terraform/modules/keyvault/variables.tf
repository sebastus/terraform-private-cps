# Variables for the Key Vault module

variable "location" {
  description = "The Azure location where Key Vault resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group for the Key Vault"
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
  description = "Object ID of the admin user who will have super user abilities in the Key Vault"
  type        = string
  
  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.admin_user_object_id))
    error_message = "Admin user object ID must be a valid GUID format."
  }
}

variable "sku_name" {
  description = "SKU name for the Key Vault (standard or premium)"
  type        = string
  default     = "standard"
  
  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "SKU name must be either 'standard' or 'premium'."
  }
}

variable "enabled_for_disk_encryption" {
  description = "Whether Azure Disk Encryption is permitted to retrieve secrets and unwrap keys"
  type        = bool
  default     = true
}

variable "enabled_for_deployment" {
  description = "Whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets"
  type        = bool
  default     = false
}

variable "enabled_for_template_deployment" {
  description = "Whether Azure Resource Manager is permitted to retrieve secrets"
  type        = bool
  default     = true
}

variable "purge_protection_enabled" {
  description = "Whether purge protection is enabled for this Key Vault"
  type        = bool
  default     = true
}

variable "soft_delete_retention_days" {
  description = "Number of days that items should be retained for once soft-deleted"
  type        = number
  default     = 7
  
  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "Soft delete retention days must be between 7 and 90."
  }
}

variable "network_access_default_action" {
  description = "Default action for network access rules (Allow or Deny)"
  type        = string
  default     = "Deny"
  
  validation {
    condition     = contains(["Allow", "Deny"], var.network_access_default_action)
    error_message = "Network access default action must be either 'Allow' or 'Deny'."
  }
}

variable "allowed_subnet_ids" {
  description = "List of subnet IDs that are allowed to access the Key Vault"
  type        = list(string)
  default     = []
}

variable "allowed_ip_ranges" {
  description = "List of IP ranges in CIDR format that are allowed to access the Key Vault"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# Private Endpoint Configuration
variable "subnet_id" {
  description = "ID of the subnet where the private endpoint will be created"
  type        = string
  default     = ""
}

variable "private_dns_zone_id" {
  description = "Private DNS zone ID for Key Vault (provided by privatedns module)"
  type        = string
  default     = ""
}

variable "enable_private_endpoint" {
  description = "Whether to create a private endpoint for the Key Vault"
  type        = bool
  default     = true
}

# Registry Customer Managed Key Configuration
variable "create_customer_managed_key" {
  description = "Whether to create a registry customer-managed encryption key in the Key Vault"
  type        = bool
  default     = true
}

variable "cmk_key_name" {
  description = "Name of the registry customer-managed encryption key"
  type        = string
  default     = "cmk-registry-key"
}

variable "cmk_key_type" {
  description = "Type of the customer-managed key (RSA or EC)"
  type        = string
  default     = "RSA"
  
  validation {
    condition     = contains(["RSA", "EC"], var.cmk_key_type)
    error_message = "Key type must be either 'RSA' or 'EC'."
  }
}

variable "cmk_key_size" {
  description = "Size of the registry customer-managed key (2048, 3072, or 4096 for RSA; 256, 384, or 521 for EC)"
  type        = number
  default     = 2048
  
  validation {
    condition = contains([2048, 3072, 4096, 256, 384, 521], var.cmk_key_size)
    error_message = "Key size must be 2048, 3072, or 4096 for RSA keys, or 256, 384, or 521 for EC keys."
  }
}

variable "cmk_key_opts" {
  description = "List of key operations allowed for the registry customer-managed key"
  type        = list(string)
  default     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
  
  validation {
    condition = alltrue([
      for opt in var.cmk_key_opts :
      contains(["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"], opt)
    ])
    error_message = "Key operations must be from: decrypt, encrypt, sign, unwrapKey, verify, wrapKey."
  }
}

# Storage Customer Managed Key Configuration
variable "create_storage_cmk" {
  description = "Whether to create a customer-managed encryption key specifically for storage"
  type        = bool
  default     = true
}

variable "storage_cmk_key_name" {
  description = "Name of the storage customer-managed encryption key"
  type        = string
  default     = "cmk-storage-key"
}