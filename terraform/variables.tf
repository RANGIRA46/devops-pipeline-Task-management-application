variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "rg-task-management-app"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefixes" {
  description = "Address prefixes for the subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "vm_size" {
  description = "Size of the virtual machines"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
  default     = "azureadmin"
}

variable "admin_password" {
  description = "Admin password for VMs (use Azure Key Vault in production)"
  type        = string
  sensitive   = true
}

variable "acr_name" {
  description = "Name of the Azure Container Registry (must be globally unique)"
  type        = string
  default     = "taskmanagementacr"
}

variable "acr_sku" {
  description = "SKU tier for Azure Container Registry"
  type        = string
  default     = "Basic"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Project   = "TaskManagementApp"
    ManagedBy = "Terraform"
  }
}
