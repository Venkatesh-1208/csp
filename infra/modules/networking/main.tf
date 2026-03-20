resource "azurerm_virtual_network" "this" {
  count               = var.deploy ? 1 : 0
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.address_space]
  tags                = var.tags
}

resource "azurerm_subnet" "app" {
  count                = var.deploy ? 1 : 0
  name                 = "app-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this[0].name
  address_prefixes     = [var.subnets.app]
}

resource "azurerm_subnet" "db" {
  count                = var.deploy ? 1 : 0
  name                 = "db-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this[0].name
  address_prefixes     = [var.subnets.db]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_subnet" "storage" {
  count                = var.deploy ? 1 : 0
  name                 = "storage-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this[0].name
  address_prefixes     = [var.subnets.storage]
}

resource "azurerm_subnet" "keyvault" {
  count                = var.deploy ? 1 : 0
  name                 = "keyvault-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this[0].name
  address_prefixes     = [var.subnets.keyvault]
}
