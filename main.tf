resource "azurerm_mssql_server" "sql_server" {
  #checkov:skip=CKV_AZURE_24:Storage account auditing may not be required as log analytics could be all thats needed
  name                                 = var.sql_server_name
  resource_group_name                  = var.resource_group_name
  location                             = var.location
  version                              = var.sql_server_version
  minimum_tls_version                  = "1.2"
  connection_policy                    = var.connection_policy
  public_network_access_enabled        = var.public_network_access_enabled
  outbound_network_restriction_enabled = var.outbound_network_restriction_enabled

  identity {
    type = "SystemAssigned"
  }

  azuread_administrator {
    login_username              = var.login_username
    object_id                   = var.object_id
    tenant_id                   = data.azurerm_client_config.current.tenant_id
    azuread_authentication_only = true
  }

  tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "sql_server_diagnostics" {
  name                       = "${var.log_analytics_workspace_name}-security-logging"
  target_resource_id         = azurerm_mssql_server.sql_server.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logs.id

  log {
    category = "SQLSecurityAuditEvents"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }
}

resource "azurerm_mssql_server_extended_auditing_policy" "sql_extended_audit_policy" {
  server_id                               = azurerm_mssql_server.sql_server.id
  enabled                                 = true
  storage_endpoint                        = var.extended_audit_policy.storage_audit_enabled == true ? data.azurerm_storage_account.monitor_storage_account.primary_blob_endpoint : null
  storage_account_access_key              = var.extended_audit_policy.storage_audit_enabled == true ? data.azurerm_storage_account.monitor_storage_account.primary_access_key : null
  storage_account_access_key_is_secondary = var.extended_audit_policy.storage_audit_enabled == true ? var.extended_audit_policy.storage_account_access_key_is_secondary : null
  retention_in_days                       = var.extended_audit_policy.storage_audit_enabled == true ? var.extended_audit_policy.retention_in_days : null
  log_monitoring_enabled                  = true
  storage_account_subscription_id         = var.extended_audit_policy.storage_audit_enabled == true ? var.extended_audit_policy.storage_account_subscription_id : null
}

resource "azurerm_mssql_server_microsoft_support_auditing_policy" "sql_ms_support_audit_policy" {
  server_id                       = azurerm_mssql_server.sql_server.id
  enabled                         = true
  blob_storage_endpoint           = var.ms_support_audit_policy.storage_audit_enabled == true ? data.azurerm_storage_account.monitor_storage_account.primary_blob_endpoint : null
  storage_account_access_key      = var.ms_support_audit_policy.storage_audit_enabled == true ? data.azurerm_storage_account.monitor_storage_account.primary_access_key : null
  log_monitoring_enabled          = true
  storage_account_subscription_id = var.ms_support_audit_policy.storage_audit_enabled == true ? var.ms_support_audit_policy.storage_account_subscription_id : null
}

resource "azurerm_mssql_server_dns_alias" "dns_alias" {
  for_each        = toset(var.dns_aliases)
  name            = each.key
  mssql_server_id = azurerm_mssql_server.sql_server.id
}

resource "azurerm_mssql_outbound_firewall_rule" "outbound_firewall_rule" {
  for_each  = toset(var.outbound_rules)
  name      = each.key
  server_id = azurerm_mssql_server.sql_server.id
}

resource "azurerm_mssql_firewall_rule" "firewall_rule" {
  for_each         = { for k in var.firewall_rules : k.name => k if k != null }
  name             = each.key
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = each.value["start_ip_address"]
  end_ip_address   = each.value["end_ip_address"]
}

resource "azurerm_mssql_virtual_network_rule" "network_rule" {
  for_each  = { for k in var.network_rules : k.name => k if k != null }
  name      = each.key
  server_id = azurerm_mssql_server.sql_server.id
  subnet_id = each.value["subnet_id"]
}

#tfsec:ignore:azure-database-threat-alert-email-set
resource "azurerm_mssql_server_security_alert_policy" "alert_policy" {
  #checkov:skip=CKV_AZURE_26:Email addresses are paramterised and emailing account admins is enforced
  resource_group_name        = var.resource_group_name
  server_name                = azurerm_mssql_server.sql_server.name
  state                      = "Enabled"
  storage_endpoint           = data.azurerm_storage_account.monitor_storage_account.primary_blob_endpoint
  storage_account_access_key = data.azurerm_storage_account.monitor_storage_account.primary_access_key
  disabled_alerts            = []
  retention_days             = var.alert_policy.retention_days
  email_account_admins       = true
  email_addresses            = var.email_addresses
}

resource "azurerm_mssql_server_transparent_data_encryption" "tde" {
  server_id = azurerm_mssql_server.sql_server.id
}

resource "azurerm_mssql_server_vulnerability_assessment" "vuln_assess" {
  server_security_alert_policy_id = azurerm_mssql_server_security_alert_policy.alert_policy.id
  storage_container_path          = "${data.azurerm_storage_account.monitor_storage_account.primary_blob_endpoint}${var.monitor_storage_account.container_name}/"
  storage_account_access_key      = data.azurerm_storage_account.monitor_storage_account.primary_access_key

  recurring_scans {
    enabled                   = true
    email_subscription_admins = true
    emails                    = var.email_addresses
  }
}

resource "azurerm_mssql_elasticpool" "elastic_pool" {
  for_each                       = { for k in var.elastic_pools : k.name => k if k != null }
  name                           = each.key
  resource_group_name            = var.resource_group_name
  location                       = var.location
  server_name                    = azurerm_mssql_server.sql_server.name
  license_type                   = each.value["license_type"]
  max_size_gb                    = each.value["max_size_gb"]
  maintenance_configuration_name = each.value["maintenance_configuration_name"]
  zone_redundant                 = each.value["zone_redundant"]

  sku {
    name     = each.value["sku_name"]
    tier     = each.value["sku_tier"]
    family   = each.value["sku_family"]
    capacity = each.value["sku_capacity"]
  }

  per_database_settings {
    min_capacity = each.value["min_capacity"]
    max_capacity = each.value["max_capacity"]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "${azurerm_mssql_server.sql_server.name}-pep-1"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = data.azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "${azurerm_mssql_server.sql_server.name}-psc-1"
    private_connection_resource_id = azurerm_mssql_server.sql_server.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
    name                 = "customdns"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.private_dns_zone.id]
  }
}

resource "azurerm_mssql_database" "sql_db" {
  for_each                            = { for k in var.databases : k.name => k if k != null }
  name                                = each.key
  server_id                           = azurerm_mssql_server.sql_server.id
  auto_pause_delay_in_minutes         = each.value["auto_pause_delay_in_minutes"]
  create_mode                         = each.value["create_mode"]
  creation_source_database_id         = each.value["creation_source_database_id"]
  elastic_pool_id                     = each.value["elastic_pool_reference"] == null ? null : azurerm_mssql_elasticpool.elastic_pool[(each.value["elastic_pool_reference"])].id
  geo_backup_enabled                  = each.value["geo_backup_enabled"]
  maintenance_configuration_name      = each.value["elastic_pool_reference"] == null ? each.value["maintenance_configuration_name"] : null
  ledger_enabled                      = each.value["ledger_enabled"]
  min_capacity                        = each.value["min_capacity"]
  restore_point_in_time               = each.value["restore_point_in_time"]
  recover_database_id                 = each.value["recover_database_id"]
  restore_dropped_database_id         = each.value["restore_dropped_database_id"]
  read_replica_count                  = each.value["read_replica_count"]
  sample_name                         = each.value["sample_name"]
  sku_name                            = each.value["sku_name"]
  storage_account_type                = each.value["storage_account_type"]
  transparent_data_encryption_enabled = true
  collation                           = each.value["collation"]
  license_type                        = each.value["license_type"]
  max_size_gb                         = each.value["max_size_gb"]
  read_scale                          = each.value["read_scale"]
  zone_redundant                      = each.value["zone_redundant"]

  dynamic "import" {
    for_each = each.value["import"] == null ? [] : [each.value["import"]]

    content {
      storage_uri                  = data.azurerm_storage_account.import_storage_account[(each.key)].primary_blob_endpoint
      storage_key                  = data.azurerm_storage_account.import_storage_account[(each.key)].primary_access_key
      storage_key_type             = "StorageAccessKey"
      administrator_login          = import.value["administrator_login"]
      administrator_login_password = var.logins[(import.value["administrator_login"])].value["password"]
      authentication_type          = import.value["authentication_type"]
      storage_account_id           = data.azurerm_storage_account.import_storage_account[(each.key)].id
    }
  }

  long_term_retention_policy {
    weekly_retention  = each.value["long_term_retention_policy"].weekly_retention
    monthly_retention = each.value["long_term_retention_policy"].monthly_retention
    yearly_retention  = each.value["long_term_retention_policy"].yearly_retention
    week_of_year      = each.value["long_term_retention_policy"].week_of_year
  }

  short_term_retention_policy {
    retention_days           = each.value["short_term_retention_policy"].retention_days
    backup_interval_in_hours = each.value["short_term_retention_policy"].backup_interval_in_hours
  }

  tags = var.tags
}

resource "azurerm_mssql_job_agent" "job_agent" {
  for_each    = { for k in var.job_agents : k.name => k if k != null }
  name        = each.key
  location    = var.location
  database_id = azurerm_mssql_database.sql_db[(each.value["database_reference"])].id
}

resource "azurerm_mssql_failover_group" "failover_group" {
  for_each                                  = { for k in var.failover_groups : k.name => k if k != null }
  name                                      = each.key
  server_id                                 = azurerm_mssql_server.sql_server.id
  databases                                 = [for k in each.value["databases"] : azurerm_mssql_database.sql_db[(k)].id]
  readonly_endpoint_failover_policy_enabled = each.value["readonly_endpoint_failover_policy_enabled"]

  partner_server {
    id = data.azurerm_mssql_server.secondary_sql_server[(each.key)].id
  }

  read_write_endpoint_failover_policy {
    mode          = each.value["read_write_endpoint_failover_policy_mode"]
    grace_minutes = each.value["read_write_endpoint_failover_policy_grace_minutes"]
  }

  tags = var.tags
}
