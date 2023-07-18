variable "sql_server_name" {
  type        = string
  description = "The name of the sql server to deploy"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group to deploy the sql server to"
}

variable "location" {
  type        = string
  description = "The location of the sql server"
}

variable "sql_server_version" {
  type        = string
  default     = "12.0"
  description = "The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server"
}

variable "connection_policy" {
  type        = string
  default     = "Default"
  description = "The connection policy the server will use. Possible values are Default, Proxy, and Redirect"
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Whether public network access is allowed for this server"
}

variable "outbound_network_restriction_enabled" {
  type        = bool
  default     = false
  description = "Whether outbound network traffic is restricted for this server"
}

variable "login_username" {
  type        = string
  description = "The login username of the Azure AD Administrator of this SQL Server"
}

variable "object_id" {
  type        = string
  description = "The object id of the Azure AD Administrator of this SQL Server"
}

variable "extended_audit_policy" {
  type = object({
    storage_audit_enabled                   = optional(bool, false)
    storage_account_access_key_is_secondary = optional(bool, false)
    retention_in_days                       = optional(number, 0)
    storage_account_subscription_id         = optional(string)
  })
  default     = null
  description = "SQL server extended audit policy"
}

variable "ms_support_audit_policy" {
  type = object({
    storage_audit_enabled           = optional(bool, false)
    storage_account_subscription_id = optional(string)
  })
  default     = null
  description = "SQL server Microsoft support audit policy"
}

variable "dns_aliases" {
  type        = list(string)
  default     = []
  description = "DNS aliases of the SQL server"
}

variable "outbound_rules" {
  type        = list(string)
  default     = []
  description = "Outbound firewall rules for the SQL server"
}

variable "firewall_rules" {
  type = list(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
  default     = []
  description = "Inbound firewall rules for the SQL server"
}

variable "network_rules" {
  type = list(object({
    name      = string
    subnet_id = string
  }))
  default     = []
  description = "Subnet rules for the sql server"
}

variable "alert_policy" {
  type = object({
    retention_days = optional(number, 0)
  })
  default     = null
  description = "SQL server extended audit policy"
}

variable "elastic_pools" {
  type = list(object({
    name                           = string
    license_type                   = optional(string, "LicenseIncluded")
    max_size_gb                    = number
    maintenance_configuration_name = optional(string, "SQL_Default")
    zone_redundant                 = bool
    sku_name                       = string
    sku_tier                       = string
    sku_family                     = string
    capacity                       = string
    min_capacity                   = number
    max_capacity                   = number
  }))
  default     = []
  description = "Elastic pools for the sql server"
}

variable "private_endpoint" {
  type = object({
    subnet_name                          = string
    virtual_network_name                 = string
    subnet_resource_group_name           = string
    private_dns_zone_name                = string
    private_dns_zone_resource_group_name = string
  })
  default     = null
  description = "Private endpoint for the sql server"
}

variable "databases" {
  type = list(object({
    name                           = string
    auto_pause_delay_in_minutes    = optional(number)
    create_mode                    = optional(string, "Default")
    creation_source_database_id    = optional(string)
    elastic_pool_reference         = optional(string)
    geo_backup_enabled             = optional(bool, true)
    maintenance_configuration_name = optional(string, "SQL_Default")
    ledger_enabled                 = optional(bool, false)
    min_capacity                   = optional(number)
    restore_point_in_time          = optional(string)
    recover_database_id            = optional(string)
    restore_dropped_database_id    = optional(string)
    read_replica_count             = optional(number)
    sample_name                    = optional(string)
    sku_name                       = string
    storage_account_type           = optional(string, "Geo")
    collation                      = optional(string, "SQL_Latin1_General_CP1_CI_AS")
    license_type                   = optional(string, "LicenseIncluded")
    max_size_gb                    = optional(number)
    read_scale                     = optional(bool, false)
    zone_redundant                 = bool
    import = optional(list(object({
      storage_account_name                = string
      storage_account_resource_group_name = string
      administrator_login                 = string
      authentication_type                 = optional(string, "ADPassword")
    })))
    long_term_retention_policy = object({
      weekly_retention  = optional(string)
      monthly_retention = optional(string)
      yearly_retention  = optional(string)
      week_of_year      = optional(string)
    })
    short_term_retention_policy = object({
      retention_days           = number
      backup_interval_in_hours = optional(number, 12)
    })
  }))
  default     = []
  description = "Databases for the sql server"
}

variable "job_agents" {
  type = list(object({
    name               = string
    database_reference = string
  }))
  default     = []
  description = "Job agents for the sql server"
}

variable "failover_groups" {
  type = list(object({
    name                                              = string
    databases                                         = list(string)
    readonly_endpoint_failover_policy_enabled         = optional(bool, false)
    read_write_endpoint_failover_policy_mode          = string
    read_write_endpoint_failover_policy_grace_minutes = optional(number)
  }))
  default     = []
  description = "Failover groups for the SQL server"
}

variable "email_addresses" {
  type        = list(string)
  description = "Additional email addresses for alerts"
}

variable "monitor_storage_account" {
  type = object({
    name                = string
    resource_group_name = string
    container_name      = string
  })
  default     = null
  description = "SQL server extended audit policy"
}

variable "logins" {
  type = map(object({
    password = string
  }))
  default     = null
  sensitive   = true
  description = "SQL server extended audit policy"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Name of Log Analytics Workspace to send diagnostics"
}

variable "log_analytics_workspace_resource_group_name" {
  type        = string
  description = "Resource Group of Log Analytics Workspace to send diagnostics"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply"
}
