# Variables for the networking module

variable "location" {
  description = "The Azure location where networking resources will be created"
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

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/18"]
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
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# VNet Peering Configuration
variable "enable_vnet_peering" {
  description = "Whether to enable VNet peering with external VNet"
  type        = bool
  default     = false
}

variable "remote_vnet_id" {
  description = "Resource ID of the remote VNet to peer with"
  type        = string
  default     = ""
  
  validation {
    condition = var.enable_vnet_peering == false || can(regex("^/subscriptions/.+/resourceGroups/.+/providers/Microsoft.Network/virtualNetworks/.+$", var.remote_vnet_id))
    error_message = "Remote VNet ID must be a valid Azure VNet resource ID when peering is enabled."
  }
}

variable "remote_vnet_name" {
  description = "Name of the remote VNet to peer with"
  type        = string
  default     = ""
}