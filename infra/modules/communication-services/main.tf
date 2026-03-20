resource "azurerm_communication_service" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  data_location       = "United States"
  tags                = var.tags
}

# Note: Email Communication Service and Domain creation takes time and typically 
# requires specific domain verification. 
resource "azurerm_email_communication_service" "this" {
  name                = "${var.name}-email"
  resource_group_name = var.resource_group_name
  data_location       = "United States"
  tags                = var.tags
}
