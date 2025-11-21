terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # Local backend for development
  backend "local" {
    path = "terraform.tfstate"
  }

  # For production, use Terraform Cloud:
  # backend "remote" {
  #   organization = "your-organization"
  #   workspaces {
  #     name = "task-management-app"
  #   }
  # }
}

provider "azurerm" {
  features {}
}
