variable "deploy" { type = bool; default = true }
variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "service_plan_id" { type = string }
variable "always_on" { type = bool; default = true }
variable "staging_slot_enabled" { type = bool; default = false }
variable "app_settings" { type = map(string); default = {} }
variable "tags" { type = map(string); default = {} }
