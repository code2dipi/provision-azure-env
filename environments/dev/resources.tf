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

resource "azurerm_subnet" "app_subnet" {
  name                 = "Subnet-App"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_subnet" "db_subnet" {
  name                 = "Subnet-Database"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_subnet" "keycloak_subnet" {
  name                 = "Subnet-Keycloak"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

# private endpoint for postgres
resource "azurerm_postgresql_flexible_server" "pg" {
  name                   = "postgres-db-server"
  resource_group_name    = azurerm_resource_group.myrg.name
  location               = azurerm_resource_group.myrg.location
  version                = "14"

  delegated_subnet_id    = azurerm_subnet.db_subnet.id

  administrator_login    = var.postgres_admin_username
  administrator_password = var.postgres_admin_password

  sku_name               = "B_Standard_B1ms"
  storage_mb             = 32768
  backup_retention_days  = 7
  geo_redundant_backup_enabled = false


}

resource "azurerm_postgresql_flexible_server_database" "testdb" {
  name      = "testdb"
  server_id = azurerm_postgresql_flexible_server.pg.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

resource "azurerm_private_endpoint" "pg_private_endpoint" {
  name                = "pg-private-endpoint"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  subnet_id           = azurerm_subnet.db_subnet.id

  private_service_connection {
    name                           = "pg-psc"
    private_connection_resource_id =  azurerm_postgresql_flexible_server.pg.id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }
}
