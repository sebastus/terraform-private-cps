# Azure Infrastructure with Terraform

This repository contains Terraform configuration for deploying Azure infrastructure including networking, Key Vault, and Azure Bastion.

## Prerequisites

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed and configured
- [Terraform](https://www.terraform.io/downloads.html) version 1.6 or higher
- Azure subscription with appropriate permissions

## Quick Start

### 1. Clone and Navigate
```powershell
cd terraform/
```

### 2. Authenticate with Azure
```powershell
az login
az account show  # Verify you're using the correct subscription
```

### 3. Set Up Environment Variables
```powershell
.\set-env.ps1  # Load Azure environment variables
```

### 4. Set Up Terraform Variables
```powershell
.\setup-tfvars.ps1  # Creates terraform.tfvars with your Object ID
```

### 5. Deploy Infrastructure
```powershell
terraform init
terraform plan
terraform apply
```

## Project Structure

```
terraform/
├── terraform.tf              # Provider configuration and versions
├── main.tf                   # Main orchestration file
├── variables.tf              # Input variable definitions
├── outputs.tf                # Output value definitions
├── terraform.tfvars.example  # Example variables file
├── modules/
│   ├── networking/           # Networking module (VNet, subnets, NSGs, Bastion)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── keyvault/            # Key Vault module (RBAC-enabled)
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── .env.example             # Environment variables template
├── set-env.ps1             # Script to load environment variables
└── setup-tfvars.ps1        # Script to create terraform.tfvars
```

## Infrastructure Components

### Networking Module
- **Virtual Network**: 16,384 IP addresses (10.0.0.0/18)
- **Subnets**: 4 subnets with 32 IP addresses each (/27)
- **Azure Bastion**: Secure remote access to VMs
- **Network Security Groups**: HTTPS and SSH access rules
- **Public IP**: For Azure Bastion service

### Key Vault Module
- **RBAC Authorization**: Modern role-based access control
- **Network Restrictions**: Subnet-based access control
- **Admin Access**: Full super user permissions for designated admin
- **Security Features**: Purge protection, soft delete, audit logging

## Configuration

### Required Variables
- `location`: Azure region for resources
- `environment`: Environment name (dev/staging/prod)
- `project_name`: Project identifier for naming
- `admin_user_object_id`: Your Azure AD Object ID for Key Vault access

### Optional Variables
All modules have sensible defaults but can be customized in `terraform.tfvars`:

```hcl
# Example customizations
keyvault_sku_name = "premium"
keyvault_soft_delete_retention_days = 30
keyvault_allowed_ip_ranges = ["203.0.113.0/24"]
```

## Getting Your Object ID

Your Object ID is required for Key Vault administrator access:

```powershell
az ad signed-in-user show --query id -o tsv
```

## Security Features

- **Network Isolation**: Key Vault denies public access by default
- **RBAC**: Modern role-based permissions instead of access policies
- **Audit Ready**: Configured for Azure Monitor integration
- **Least Privilege**: Minimal required permissions for each component
- **Lifecycle Management**: Tags are ignored to prevent drift from Azure policies

## Lifecycle Management

This configuration uses lifecycle blocks to ignore tag changes on all resources. This prevents Terraform from constantly trying to update tags that may be managed by:
- Azure Policies
- Cost Management tools
- Governance systems
- Other teams or processes

For detailed information, see [Lifecycle Management Documentation](docs/lifecycle-management.md).

## Environment Variables

The configuration uses environment variables for authentication:
- `ARM_SUBSCRIPTION_ID`: Your Azure subscription ID
- `ARM_TENANT_ID`: Your Azure tenant ID

## Troubleshooting

### Authentication Issues
```powershell
# Re-authenticate
az login
az account show

# Reload environment variables
.\set-env.ps1
```

### Object ID Issues
```powershell
# Get your Object ID
az ad signed-in-user show --query id -o tsv

# Update terraform.tfvars with the correct Object ID
```

### Module Issues
```powershell
# Reinitialize Terraform
terraform init -upgrade
```

## Cleanup

To destroy all resources:
```powershell
terraform destroy
```

**Warning**: This will permanently delete all resources. Ensure you have backups of any important data.

## Support

For issues or questions:
1. Check the Terraform plan output for validation errors
2. Review Azure Portal for resource status
3. Check Azure Activity Log for deployment errors