# ---------------------------------------------------------------------------
# VNet Module - Virtual Network + App/Data Subnets
# ---------------------------------------------------------------------------
resource "azurerm_virtual_network" "this" {
  count               = var.deploy ? 1 : 0
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = [var.address_space]
  tags                = var.tags
}

# App Subnet (with App Service VNet Integration delegation)
resource "azurerm_subnet" "app" {
  count                = var.deploy ? 1 : 0
  name                 = var.snet_app_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this[0].name
  address_prefixes     = [var.snet_app_prefix]

  delegation {
    name = "appservice-delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
      ]
    }
  }
}

# Data Subnet (private endpoints / DB access)
resource "azurerm_subnet" "data" {
  count                = var.deploy ? 1 : 0
  name                 = var.snet_data_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = one(azurerm_virtual_network.this[*].name)
  address_prefixes     = [var.snet_data_prefix]
}
