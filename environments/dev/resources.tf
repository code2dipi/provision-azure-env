resource "azurerm_resource_group" "myrg" {
    name     = var.resource_group_name
    location = var.location
  
}
resource "azurerm_virtual_network" "myvnet" {
  name                = "vnet-terraform-dev"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}
resource "azurerm_subnet" "mysubnet" {
  name                 = "subnet-terraform-dev"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.1.0/24"]
}