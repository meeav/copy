resource "azurerm_automation_account" "automation" {
  name                          = "aa1"
  location                      = "get"
  resource_group_name           = "rg"
  sku_name                      = 
  tags                          = 
  public_network_access_enabled = 
}
