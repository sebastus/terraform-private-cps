# Variables for the Identity module

variable "location" {
  description = "The Azure location where identity resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group for the managed identity"
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

variable "key_vault_id" {
  description = "The ID of the Key Vault to grant access to"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}