data "azurerm_client_config" "current" {}

data "azurerm_mssql_server" "secondary_sql_server" {
  for_each            = { for k in var.failover_groups : k.name => k if k != null }
  name                = each.value["secondary_server_name"]
  resource_group_name = each.value["secondary_server_resource_group_name"]
}

data "azurerm_storage_account" "monitor_storage_account" {
  provider            = azurerm.logs
  name                = var.monitor_storage_account.name
  resource_group_name = var.monitor_storage_account.resource_group_name
}

data "azurerm_storage_account" "import_storage_account" {
  for_each            = { for k in var.databases : k.name => k if k.import != null }
  name                = each.value["import"].storage_account_name
  resource_group_name = each.value["import"].storage_account_resource_group_name
}

data "azurerm_subnet" "subnet" {
  name                 = var.private_endpoint.subnet_name
  virtual_network_name = var.private_endpoint.virtual_network_name
  resource_group_name  = var.private_endpoint.subnet_resource_group_name
}

data "azurerm_private_dns_zone" "private_dns_zone" {
  provider            = azurerm.dns
  name                = var.private_endpoint.private_dns_zone_name
  resource_group_name = var.private_endpoint.private_dns_zone_resource_group_name
}

data "azurerm_log_analytics_workspace" "logs" {
  provider            = azurerm.logs
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_workspace_resource_group_name
}
