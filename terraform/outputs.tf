output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.main.location
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = azurerm_subnet.main.id
}

output "web_vm_public_ip" {
  description = "Public IP address of the web VM"
  value       = azurerm_public_ip.web.ip_address
}

output "web_vm_private_ip" {
  description = "Private IP address of the web VM"
  value       = azurerm_network_interface.web.private_ip_address
}

output "db_vm_public_ip" {
  description = "Public IP address of the database VM"
  value       = azurerm_public_ip.db.ip_address
}

output "db_vm_private_ip" {
  description = "Private IP address of the database VM"
  value       = azurerm_network_interface.db.private_ip_address
}

output "acr_login_server" {
  description = "Login server URL for the Azure Container Registry"
  value       = azurerm_container_registry.main.login_server
}

output "acr_admin_username" {
  description = "Admin username for the Azure Container Registry"
  value       = azurerm_container_registry.main.admin_username
  sensitive   = true
}

output "acr_admin_password" {
  description = "Admin password for the Azure Container Registry"
  value       = azurerm_container_registry.main.admin_password
  sensitive   = true
}

output "acr_id" {
  description = "ID of the Azure Container Registry"
  value       = azurerm_container_registry.main.id
}
