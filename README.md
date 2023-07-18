# az-mssql-tf

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.20 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.20 |
| <a name="provider_azurerm.dns"></a> [azurerm.dns](#provider\_azurerm.dns) | ~> 3.20 |
| <a name="provider_azurerm.logs"></a> [azurerm.logs](#provider\_azurerm.logs) | ~> 3.20 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_diagnostic_setting.sql_server_diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_mssql_database.sql_db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database) | resource |
| [azurerm_mssql_elasticpool.elastic_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_elasticpool) | resource |
| [azurerm_mssql_failover_group.failover_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_failover_group) | resource |
| [azurerm_mssql_firewall_rule.firewall_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_firewall_rule) | resource |
| [azurerm_mssql_job_agent.job_agent](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_job_agent) | resource |
| [azurerm_mssql_outbound_firewall_rule.outbound_firewall_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_outbound_firewall_rule) | resource |
| [azurerm_mssql_server.sql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server) | resource |
| [azurerm_mssql_server_dns_alias.dns_alias](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_dns_alias) | resource |
| [azurerm_mssql_server_extended_auditing_policy.sql_extended_audit_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_extended_auditing_policy) | resource |
| [azurerm_mssql_server_microsoft_support_auditing_policy.sql_ms_support_audit_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_microsoft_support_auditing_policy) | resource |
| [azurerm_mssql_server_security_alert_policy.alert_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_security_alert_policy) | resource |
| [azurerm_mssql_server_transparent_data_encryption.tde](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_transparent_data_encryption) | resource |
| [azurerm_mssql_server_vulnerability_assessment.vuln_assess](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_vulnerability_assessment) | resource |
| [azurerm_mssql_virtual_network_rule.network_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_virtual_network_rule) | resource |
| [azurerm_private_endpoint.private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_log_analytics_workspace.logs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_mssql_server.secondary_sql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/mssql_server) | data source |
| [azurerm_private_dns_zone.private_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_storage_account.import_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |
| [azurerm_storage_account.monitor_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_policy"></a> [alert\_policy](#input\_alert\_policy) | SQL server extended audit policy | <pre>object({<br>    retention_days = optional(number, 0)<br>  })</pre> | `null` | no |
| <a name="input_connection_policy"></a> [connection\_policy](#input\_connection\_policy) | The connection policy the server will use. Possible values are Default, Proxy, and Redirect | `string` | `"Default"` | no |
| <a name="input_databases"></a> [databases](#input\_databases) | Databases for the sql server | <pre>list(object({<br>    name                           = string<br>    auto_pause_delay_in_minutes    = optional(number)<br>    create_mode                    = optional(string, "Default")<br>    creation_source_database_id    = optional(string)<br>    elastic_pool_reference         = optional(string)<br>    geo_backup_enabled             = optional(bool, true)<br>    maintenance_configuration_name = optional(string, "SQL_Default")<br>    ledger_enabled                 = optional(bool, false)<br>    min_capacity                   = optional(number)<br>    restore_point_in_time          = optional(string)<br>    recover_database_id            = optional(string)<br>    restore_dropped_database_id    = optional(string)<br>    read_replica_count             = optional(number)<br>    sample_name                    = optional(string)<br>    sku_name                       = string<br>    storage_account_type           = optional(string, "Geo")<br>    collation                      = optional(string, "SQL_Latin1_General_CP1_CI_AS")<br>    license_type                   = optional(string, "LicenseIncluded")<br>    max_size_gb                    = optional(number)<br>    read_scale                     = optional(bool, false)<br>    zone_redundant                 = bool<br>    import = optional(list(object({<br>      storage_account_name                = string<br>      storage_account_resource_group_name = string<br>      administrator_login                 = string<br>      authentication_type                 = optional(string, "ADPassword")<br>    })))<br>    long_term_retention_policy = object({<br>      weekly_retention  = optional(string)<br>      monthly_retention = optional(string)<br>      yearly_retention  = optional(string)<br>      week_of_year      = optional(string)<br>    })<br>    short_term_retention_policy = object({<br>      retention_days           = number<br>      backup_interval_in_hours = optional(number, 12)<br>    })<br>  }))</pre> | `[]` | no |
| <a name="input_dns_aliases"></a> [dns\_aliases](#input\_dns\_aliases) | DNS aliases of the SQL server | `list(string)` | `[]` | no |
| <a name="input_elastic_pools"></a> [elastic\_pools](#input\_elastic\_pools) | Elastic pools for the sql server | <pre>list(object({<br>    name                           = string<br>    license_type                   = optional(string, "LicenseIncluded")<br>    max_size_gb                    = number<br>    maintenance_configuration_name = optional(string, "SQL_Default")<br>    zone_redundant                 = bool<br>    sku_name                       = string<br>    sku_tier                       = string<br>    sku_family                     = string<br>    capacity                       = string<br>    min_capacity                   = number<br>    max_capacity                   = number<br>  }))</pre> | `[]` | no |
| <a name="input_email_addresses"></a> [email\_addresses](#input\_email\_addresses) | Additional email addresses for alerts | `list(string)` | n/a | yes |
| <a name="input_extended_audit_policy"></a> [extended\_audit\_policy](#input\_extended\_audit\_policy) | SQL server extended audit policy | <pre>object({<br>    storage_audit_enabled                   = optional(bool, false)<br>    storage_account_access_key_is_secondary = optional(bool, false)<br>    retention_in_days                       = optional(number, 0)<br>    storage_account_subscription_id         = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_failover_groups"></a> [failover\_groups](#input\_failover\_groups) | Failover groups for the SQL server | <pre>list(object({<br>    name                                              = string<br>    databases                                         = list(string)<br>    readonly_endpoint_failover_policy_enabled         = optional(bool, false)<br>    read_write_endpoint_failover_policy_mode          = string<br>    read_write_endpoint_failover_policy_grace_minutes = optional(number)<br>  }))</pre> | `[]` | no |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | Inbound firewall rules for the SQL server | <pre>list(object({<br>    name             = string<br>    start_ip_address = string<br>    end_ip_address   = string<br>  }))</pre> | `[]` | no |
| <a name="input_job_agents"></a> [job\_agents](#input\_job\_agents) | Job agents for the sql server | <pre>list(object({<br>    name               = string<br>    database_reference = string<br>  }))</pre> | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | The location of the sql server | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Name of Log Analytics Workspace to send diagnostics | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_resource_group_name"></a> [log\_analytics\_workspace\_resource\_group\_name](#input\_log\_analytics\_workspace\_resource\_group\_name) | Resource Group of Log Analytics Workspace to send diagnostics | `string` | n/a | yes |
| <a name="input_login_username"></a> [login\_username](#input\_login\_username) | The login username of the Azure AD Administrator of this SQL Server | `string` | n/a | yes |
| <a name="input_logins"></a> [logins](#input\_logins) | SQL server extended audit policy | <pre>map(object({<br>    password = string<br>  }))</pre> | `null` | no |
| <a name="input_monitor_storage_account"></a> [monitor\_storage\_account](#input\_monitor\_storage\_account) | SQL server extended audit policy | <pre>object({<br>    name                = string<br>    resource_group_name = string<br>    container_name      = string<br>  })</pre> | `null` | no |
| <a name="input_ms_support_audit_policy"></a> [ms\_support\_audit\_policy](#input\_ms\_support\_audit\_policy) | SQL server Microsoft support audit policy | <pre>object({<br>    storage_audit_enabled           = optional(bool, false)<br>    storage_account_subscription_id = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_network_rules"></a> [network\_rules](#input\_network\_rules) | Subnet rules for the sql server | <pre>list(object({<br>    name      = string<br>    subnet_id = string<br>  }))</pre> | `[]` | no |
| <a name="input_object_id"></a> [object\_id](#input\_object\_id) | The object id of the Azure AD Administrator of this SQL Server | `string` | n/a | yes |
| <a name="input_outbound_network_restriction_enabled"></a> [outbound\_network\_restriction\_enabled](#input\_outbound\_network\_restriction\_enabled) | Whether outbound network traffic is restricted for this server | `bool` | `false` | no |
| <a name="input_outbound_rules"></a> [outbound\_rules](#input\_outbound\_rules) | Outbound firewall rules for the SQL server | `list(string)` | `[]` | no |
| <a name="input_private_endpoint"></a> [private\_endpoint](#input\_private\_endpoint) | Private endpoint for the sql server | <pre>object({<br>    subnet_name                          = string<br>    virtual_network_name                 = string<br>    subnet_resource_group_name           = string<br>    private_dns_zone_name                = string<br>    private_dns_zone_resource_group_name = string<br>  })</pre> | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether public network access is allowed for this server | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group to deploy the sql server to | `string` | n/a | yes |
| <a name="input_sql_server_name"></a> [sql\_server\_name](#input\_sql\_server\_name) | The name of the sql server to deploy | `string` | n/a | yes |
| <a name="input_sql_server_version"></a> [sql\_server\_version](#input\_sql\_server\_version) | The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server | `string` | `"12.0"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->