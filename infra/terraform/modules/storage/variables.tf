variable "deploy" { type = bool; default = true }
variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "account_replication_type" { type = string; default = "LRS" }
variable "containers" { type = list(string); default = [] }
variable "key_vault_id" { type = string; default = null }
variable "tags" { type = map(string); default = {} }
