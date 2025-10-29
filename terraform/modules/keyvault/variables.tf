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