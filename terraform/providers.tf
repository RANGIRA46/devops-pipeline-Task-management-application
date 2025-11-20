terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # Terraform Cloud backend configuration
  # To use this, set the organization and workspace names
  # and authenticate with `terraform login`
  backend "remote" {
    organization = "your-organization"

    workspaces {
      name = "task-management-app"
    }
  }
}

provider "azurerm" {
  features {}
}
