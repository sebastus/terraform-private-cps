# Terraform Lifecycle Management

This document explains the lifecycle management approach used in this Terraform configuration.

## Tag Management

All resources with tags include a lifecycle block that ignores tag changes:

```hcl
lifecycle {
  ignore_changes = [tags]
}
```

### Why Ignore Tag Changes?

1. **Azure Policy Compliance**: Azure policies may automatically add or modify tags
2. **Cost Management**: Azure Cost Management may add billing-related tags
3. **Governance**: Enterprise governance tools may enforce organizational tags
4. **Team Collaboration**: Different teams may add tags for their specific needs
5. **Drift Prevention**: Prevents Terraform from constantly trying to "fix" externally managed tags

### Best Practices

- **Define Core Tags**: Set essential tags in Terraform (Environment, Project, ManagedBy)
- **Allow External Tags**: Let other systems add additional tags without interference
- **Document Tag Strategy**: Clearly document which tags are managed by Terraform vs external systems

## Random Resource Management

Random resources (used for unique naming) include lifecycle blocks to prevent unnecessary recreation:

```hcl
lifecycle {
  ignore_changes = [keepers]
}
```

### Why Ignore Keepers?

- **Stability**: Prevents random recreation of suffix values
- **Naming Consistency**: Maintains consistent resource names across deployments
- **Dependency Management**: Avoids cascading updates when random values change

## Resource-Specific Lifecycle Rules

### Key Vault
- **Tags**: Ignored to allow Azure policies and governance tools to manage additional tags
- **Access Policies**: Not used (RBAC is preferred), but if added later, consider lifecycle rules

### Networking Resources
- **Tags**: Ignored on all networking resources (VNet, subnets, NSGs, public IPs)
- **Security Rules**: Managed by Terraform, not ignored (important for security compliance)

### Azure Bastion
- **Tags**: Ignored to allow operational tags
- **IP Configuration**: Managed by Terraform (critical for functionality)

## When NOT to Use ignore_changes

- **Security-Critical Settings**: Never ignore changes to security-related configurations
- **Network Rules**: Keep network security rules under Terraform control
- **Access Permissions**: Maintain control over RBAC assignments
- **Resource Configuration**: Core resource settings should remain under Terraform management

## Future Considerations

### Potential Additional Lifecycle Rules

```hcl
# Example: Prevent accidental deletion of critical resources
lifecycle {
  prevent_destroy = true
  ignore_changes = [tags]
}

# Example: Replace before destroy for zero-downtime updates
lifecycle {
  create_before_destroy = true
  ignore_changes = [tags]
}
```

### Monitoring and Alerting

Consider implementing monitoring for:
- Tag drift beyond expected patterns
- Unexpected resource modifications
- Security configuration changes

## Troubleshooting

### Tag-Related Plan Changes

If Terraform shows tag changes in plan output:
1. Verify lifecycle blocks are in place
2. Check if tags are being modified outside Terraform
3. Consider if the tag changes are expected and safe to ignore

### Resource Recreation Issues

If resources are being unnecessarily recreated:
1. Check random resource keepers
2. Review lifecycle blocks for critical resources
3. Consider adding `prevent_destroy` for critical infrastructure

### Override When Necessary

To temporarily manage tags through Terraform:
```hcl
# Temporarily comment out the lifecycle block
# lifecycle {
#   ignore_changes = [tags]
# }
```

Remember to restore the lifecycle block after making intended tag changes.