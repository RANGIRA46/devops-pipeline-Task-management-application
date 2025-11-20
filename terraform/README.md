# Terraform Infrastructure for Task Management Application

This directory contains Terraform configuration files for provisioning Azure infrastructure for the Task Management Application.

## Architecture Overview

The infrastructure includes:

- **Resource Group**: Container for all Azure resources
- **Virtual Network**: Network with subnet for VM communication
- **Network Security Group**: Security rules for HTTP, HTTPS, SSH, and application traffic
- **Virtual Machines**: Two Ubuntu 22.04 LTS VMs
  - Web VM: Hosts the application frontend/backend
  - Database VM: Hosts the database server
- **Azure Container Registry (ACR)**: Private container registry for Docker images
- **Public IPs**: Static public IPs for both VMs

## Prerequisites

1. **Terraform**: Install Terraform >= 1.0
   ```bash
   # Download from https://www.terraform.io/downloads
   ```

2. **Azure CLI**: Install and authenticate
   ```bash
   az login
   az account set --subscription "your-subscription-id"
   ```

3. **Terraform Cloud** (Optional): For remote backend
   ```bash
   terraform login
   ```

## Configuration

### 1. Set Up Variables

Copy the example variables file and customize it:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your values:
- Update `acr_name` to a globally unique name (only alphanumeric characters)
- Set `admin_password` or use environment variable: `export TF_VAR_admin_password="YourSecurePassword"`
- Adjust `location`, `vm_size`, and other parameters as needed

### 2. Configure Backend (Optional)

If using Terraform Cloud backend, update `providers.tf`:

```hcl
backend "remote" {
  organization = "your-organization-name"
  
  workspaces {
    name = "task-management-app"
  }
}
```

Or use local backend by removing/commenting out the `backend` block.

## Usage

### Initialize Terraform

```bash
cd terraform
terraform init
```

### Validate Configuration

```bash
terraform validate
```

### Plan Infrastructure

```bash
terraform plan
```

### Apply Infrastructure

```bash
terraform apply
```

Review the plan and type `yes` to confirm.

### View Outputs

After successful deployment:

```bash
terraform output
```

To view sensitive outputs:

```bash
terraform output acr_admin_username
terraform output acr_admin_password
```

### Destroy Infrastructure

When you need to tear down the infrastructure:

```bash
terraform destroy
```

## Important Notes

### Security Considerations

1. **Passwords**: Never commit `terraform.tfvars` with real passwords. Use environment variables or Azure Key Vault.
2. **NSG Rules**: Review and restrict the source IP ranges in production environments.
3. **SSH Keys**: Consider using SSH keys instead of passwords for VM authentication.
4. **ACR**: In production, disable admin user and use Azure AD authentication.

### Cost Optimization

- VMs use `Standard_B2s` (burstable) instances by default for cost savings
- ACR uses `Basic` SKU for development (consider `Standard` or `Premium` for production)
- Public IPs use Standard SKU with static allocation

### Customization

You can customize the infrastructure by modifying:

- `variables.tf`: Add new variables or change defaults
- `main.tf`: Modify resources or add new ones
- `terraform.tfvars`: Set environment-specific values

## Outputs

After deployment, you'll receive:

- Resource group name and location
- Virtual network and subnet IDs
- Public and private IP addresses for both VMs
- ACR login server URL and credentials

## Connecting to Resources

### SSH to VMs

```bash
ssh azureadmin@<web_vm_public_ip>
ssh azureadmin@<db_vm_public_ip>
```

### Login to ACR

```bash
az acr login --name <acr_name>
# or
docker login <acr_login_server> -u <acr_admin_username> -p <acr_admin_password>
```

## Troubleshooting

### ACR Name Conflict

If you get a name conflict for ACR, the name must be globally unique. Change `acr_name` in your `terraform.tfvars`.

### Authentication Issues

Ensure you're logged into Azure:

```bash
az account show
```

### State Lock Issues

If using Terraform Cloud and encountering lock issues:

```bash
terraform force-unlock <lock-id>
```

## File Structure

```
terraform/
├── README.md                    # This file
├── providers.tf                 # Provider and backend configuration
├── variables.tf                 # Variable definitions
├── main.tf                      # Main infrastructure resources
├── outputs.tf                   # Output definitions
├── terraform.tfvars.example     # Example variables file
└── terraform.tfvars             # Your variables (gitignored)
```

## Additional Resources

- [Terraform Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Architecture Center](https://docs.microsoft.com/en-us/azure/architecture/)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)
