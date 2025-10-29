# Terraform configuration for Azure provider
# This configuration uses Azure CLI for authentication (az login required)
# Follows Azure Verified Modules specifications and best practices

terraform {
  # Require Terraform version 1.6 or higher for optimal Azure provider support
  required_version = "~> 1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0" # Latest major version following Azure Verified Modules specs
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# Configure the Azure Resource Manager Provider
provider "azurerm" {
  # The Azure provider uses environment variables for authentication
  # Set the following environment variables:
  # ARM_SUBSCRIPTION_ID - Your Azure subscription ID
  # ARM_CLIENT_ID - Service principal client ID (optional, uses Azure CLI if not set)
  # ARM_CLIENT_SECRET - Service principal secret (optional, uses Azure CLI if not set)
  # ARM_TENANT_ID - Azure tenant ID (optional, uses Azure CLI if not set)

  # Alternatively, for Azure CLI authentication, just ensure you're logged in with 'az login'
  # The provider will automatically use your Azure CLI credentials

  # Use Azure AD (RBAC) for storage account access instead of shared access keys
  storage_use_azuread = true

  resource_provider_registrations = "none"

  features {
    # Enable all features block - required for azurerm provider 2.0+
    # This block can be customized with specific feature configurations

    resource_group {
      # Prevent accidental deletion of resource groups containing resources
      prevent_deletion_if_contains_resources = true
    }

    key_vault {
      # Purge soft-deleted Key Vaults on destroy
      purge_soft_delete_on_destroy = true
      # Recover soft-deleted Key Vaults during create
      recover_soft_deleted_key_vaults = true
    }
  }
}