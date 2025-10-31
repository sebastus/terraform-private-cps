# Variables for the Terraform configuration

variable "location" {
  description = "The Azure location where resources will be created"
  type        = string
  default     = "East US"

  validation {
    condition = contains([
      "East US", "East US 2", "West US", "West US 2", "West US 3",
      "Central US", "North Central US", "South Central US", "West Central US",
      "Canada Central", "Canada East", "Brazil South", "UK South", "UK West",
      "West Europe", "North Europe", "France Central", "Germany West Central",
      "Switzerland North", "Norway East", "Sweden Central", "Australia East",
      "Australia Southeast", "Southeast Asia", "East Asia", "Japan East",
      "Japan West", "Korea Central", "Korea South", "Central India",
      "South India", "West India"
    ], var.location)
    error_message = "The location must be a valid Azure region."
  }
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
  default     = "cps-private"

  validation {
    condition     = can(regex("^[a-z0-9-]{3,20}$", var.project_name))
    error_message = "Project name must be 3-20 characters, lowercase letters, numbers, and hyphens only."
  }
}

variable "admin_user_object_id" {
  description = "Object ID of the admin user who will have super user abilities in Azure resources"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.admin_user_object_id))
    error_message = "Admin user object ID must be a valid GUID format. You can get this from: az ad signed-in-user show --query id -o tsv"
  }
}

# Networking configuration variables
variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.1.0.0/18"]

  validation {
    condition = alltrue([
      for cidr in var.vnet_address_space :
      can(cidrhost(cidr, 0))
    ])
    error_message = "All VNet address spaces must be valid CIDR blocks."
  }
}

variable "subnet_address_prefixes" {
  description = "Address prefixes for the four subnets (optional - will be computed automatically if not provided)"
  type = object({
    subnet1 = list(string)
    subnet2 = list(string)
    subnet3 = list(string)
    subnet4 = list(string)
  })
  default = null

  validation {
    condition = var.subnet_address_prefixes == null || alltrue([
      for subnet_name, prefixes in var.subnet_address_prefixes :
      alltrue([
        for prefix in prefixes :
        can(cidrhost(prefix, 0))
      ])
    ])
    error_message = "All subnet address prefixes must be valid CIDR blocks."
  }
}

# Storage account configuration variables
variable "storage_public_access_enabled" {
  description = "Whether to enable public network access to the storage account"
  type        = bool
  default     = true
}

variable "storage_allowed_ip_ranges" {
  description = "List of IP addresses or CIDR blocks allowed to access the storage account when public access is enabled"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for ip in var.storage_allowed_ip_ranges :
      can(cidrhost(ip, 0)) || can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", ip))
    ])
    error_message = "All IP ranges must be valid IP addresses or CIDR blocks."
  }
}

# VNet Peering configuration variables
variable "enable_vnet_peering" {
  description = "Whether to enable VNet peering with the remote VNet (vnet-tf-private-box-frpvpl)"
  type        = bool
  default     = false
}

variable "remote_vnet_id" {
  description = "Resource ID of the remote VNet (vnet-tf-private-box-frpvpl) to peer with"
  type        = string
  default     = ""

  validation {
    condition     = var.enable_vnet_peering == false || can(regex("^/subscriptions/.+/resourceGroups/.+/providers/Microsoft.Network/virtualNetworks/.+$", var.remote_vnet_id))
    error_message = "Remote VNet ID must be a valid Azure VNet resource ID when peering is enabled."
  }
}

# Terraform client IP configuration
variable "terraform_client_ip" {
  description = "IP address of the Terraform client that needs access to storage and key vault firewalls"
  type        = string
  default     = ""
  
  validation {
    condition     = var.terraform_client_ip == "" || can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.terraform_client_ip))
    error_message = "Terraform client IP must be a valid IPv4 address."
  }
}