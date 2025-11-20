# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags = merge(var.tags, {
    Environment = var.environment
  })
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.environment}-task-management"
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags = merge(var.tags, {
    Environment = var.environment
  })
}

# Subnet
resource "azurerm_subnet" "main" {
  name                 = "subnet-${var.environment}-task-management"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.subnet_address_prefixes
}

# Network Security Group
resource "azurerm_network_security_group" "main" {
  name                = "nsg-${var.environment}-task-management"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags = merge(var.tags, {
    Environment = var.environment
  })

  # Allow SSH
  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow HTTP
  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow HTTPS
  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow application port
  security_rule {
    name                       = "AllowApp"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

# Public IP for Web VM
resource "azurerm_public_ip" "web" {
  name                = "pip-${var.environment}-web"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = merge(var.tags, {
    Environment = var.environment
    Component   = "Web"
  })
}

# Network Interface for Web VM
resource "azurerm_network_interface" "web" {
  name                = "nic-${var.environment}-web"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags = merge(var.tags, {
    Environment = var.environment
    Component   = "Web"
  })

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web.id
  }
}

# Web Virtual Machine
resource "azurerm_linux_virtual_machine" "web" {
  name                            = "vm-${var.environment}-web"
  location                        = azurerm_resource_group.main.location
  resource_group_name             = azurerm_resource_group.main.name
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.web.id,
  ]
  tags = merge(var.tags, {
    Environment = var.environment
    Component   = "Web"
  })

  os_disk {
    name                 = "osdisk-${var.environment}-web"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

# Public IP for Database VM
resource "azurerm_public_ip" "db" {
  name                = "pip-${var.environment}-db"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = merge(var.tags, {
    Environment = var.environment
    Component   = "Database"
  })
}

# Network Interface for Database VM
resource "azurerm_network_interface" "db" {
  name                = "nic-${var.environment}-db"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags = merge(var.tags, {
    Environment = var.environment
    Component   = "Database"
  })

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.db.id
  }
}

# Database Virtual Machine
resource "azurerm_linux_virtual_machine" "db" {
  name                            = "vm-${var.environment}-db"
  location                        = azurerm_resource_group.main.location
  resource_group_name             = azurerm_resource_group.main.name
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.db.id,
  ]
  tags = merge(var.tags, {
    Environment = var.environment
    Component   = "Database"
  })

  os_disk {
    name                 = "osdisk-${var.environment}-db"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

# Azure Container Registry
resource "azurerm_container_registry" "main" {
  name                = var.acr_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = var.acr_sku
  admin_enabled       = true
  tags = merge(var.tags, {
    Environment = var.environment
  })
}
